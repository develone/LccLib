unit form_template;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, Menus, LCLType, StdCtrls, ExtCtrls, Spin, lcc_app_common_settings,
  lcc_comport, lcc_ethernetclient, lcc_nodemanager, lcc_ethenetserver,
  form_settings, file_utilities, lcc_messages, form_logging, lcc_defines,
  lcc_utilities, frame_lcc_logging, lcc_can_message_assembler_disassembler;

const
  BUNDLENAME             = 'LCCAppTemplate';
  PATH_LINUX_APP_FOLDER  = 'lccapptemplate/';
  PATH_SETTINGS_FILE     = 'settings.ini';

type

  { TMyRootNode }

  TMyRootNode = class(TLccDefaultRootNode)
  public
    constructor Create(AnOwner: TComponent); override;
  end;

  { TFormTemplate }

  TFormTemplate = class(TForm)
    ActionSendGlobalVerifyNodeMsg: TAction;
    ActionLccLogin: TAction;
    ActionToolsSettingsShowWin: TAction;
    ActionToolsPreferenceShowMac: TAction;
    ActionHelpAboutShow: TAction;
    ActionMsgTrace: TAction;
    ActionComPortConnect: TAction;
    ActionEthenetClientConnect: TAction;
    ActionEthernetServerConnect: TAction;
    ActionList: TActionList;
    ButtonCreateVirtualNodes: TButton;
    ButtonSendVerifyNodeMsg: TButton;
    ImageListToolbar: TImageList;
    Label1: TLabel;
    LabelServerConnections: TLabel;
    LccComPort: TLccComPort;
    LccEthernetClient: TLccEthernetClient;
    LccEthernetServer: TLccEthernetServer;
    LccNodeManager: TLccNodeManager;
    LccSettings: TLccSettings;
    ListViewServerConnections: TListView;
    MainMenu: TMainMenu;
    MenuItemToolsSettings: TMenuItem;
    MenuItemTools: TMenuItem;
    MenuItemHelp: TMenuItem;
    Panel2: TPanel;
    PanelAddOns: TPanel;
    PanelAppSpace: TPanel;
    SpinEditVNodes: TSpinEdit;
    SplitterApp: TSplitter;
    StatusBarMain: TStatusBar;
    ToolBarMain: TToolBar;
    ToolButtonLccLogIn: TToolButton;
    ToolButtonSeparator: TToolButton;
    ToolButtonMsgTrace: TToolButton;
    ToolButtonComPort: TToolButton;
    ToolButtonEthernetClient: TToolButton;
    ToolButtonEthernetServer: TToolButton;
    procedure ActionComPortConnectExecute(Sender: TObject);
    procedure ActionEthenetClientConnectExecute(Sender: TObject);
    procedure ActionEthernetServerConnectExecute(Sender: TObject);
    procedure ActionLccLoginExecute(Sender: TObject);
    procedure ActionMsgTraceExecute(Sender: TObject);
    procedure ActionSendGlobalVerifyNodeMsgExecute(Sender: TObject);
    procedure ActionToolsPreferenceShowMacExecute(Sender: TObject);
    procedure ActionToolsSettingsShowWinExecute(Sender: TObject);
    procedure ButtonCreateVirtualNodesClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure LccComPortConnectionStateChange(Sender: TObject; ComPortRec: TLccComPortRec);
    procedure LccComPortErrorMessage(Sender: TObject; ComPortRec: TLccComPortRec);
    procedure LccEthernetClientConnectionStateChange(Sender: TObject; EthernetRec: TLccEthernetRec);
    procedure LccEthernetClientErrorMessage(Sender: TObject; EthernetRec: TLccEthernetRec);
    procedure LccEthernetServerConnectionStateChange(Sender: TObject; EthernetRec: TLccEthernetRec);
    procedure LccNodeManagerAliasIDChanged(Sender: TObject; LccSourceNode: TLccNode);
    procedure LccNodeManagerLccGetRootNodeClass(Sender: TObject; var NodeClass: TLccOwnedNodeClass);
    procedure LccNodeManagerNodeIDChanged(Sender: TObject; LccSourceNode: TLccNode);
    procedure LccNodeManagerRequestMessageSend(Sender: TObject; LccMessage: TLccMessage);
  private
    FAppAboutCmd: TMenuItem;
    FShownOnce: Boolean;
    {$IFDEF DARWIN}
    FOSXMenu: TMenuItem;
    FOSXSep1Cmd: TMenuItem;
    FOSXPrefCmd: TMenuItem;
    {$ENDIF}
  private
    { private declarations }
    property AppAboutCmd: TMenuItem read FAppAboutCmd write FAppAboutCmd;
    {$IFDEF DARWIN}
    property OSXMenu: TMenuItem read FOSXMenu write FOSXMenu;
    property OSXSep1Cmd: TMenuItem read FOSXSep1Cmd write FOSXSep1Cmd;
    property OSXPrefCmd: TMenuItem read FOSXPrefCmd write FOSXPrefCmd;
    {$ENDIF}
     property ShownOnce: Boolean read FShownOnce write FShownOnce;
  protected
    procedure OnTraceFormHideEvent(Sender: TObject);
  public
    { public declarations }
    procedure CreateVirtualNode(Offset: Int64);
  end;

var
  FormTemplate: TFormTemplate;

implementation

{$R *.lfm}

{ TMyRootNode }

constructor TMyRootNode.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
  // Define what Protcol this Node Supports

  // Common Protocols

  ProtocolSupport.Datagram := True;                   // We support CDI so we must support datagrams
  ProtocolSupport.MemConfig := True;                  // We support CDI so we must support datagrams
  ProtocolSupport.CDI := True;                        // We Support CDI
  ProtocolSupport.EventExchange := True;              // We support Events
  ProtocolSupport.SimpleNodeInfo := True;             // We Support SNIP
  ProtocolSupport.ACDI := False;                      // We don't support ACDI
  ProtocolSupport.Stream := False;
  ProtocolSupport.RemoteButton := False;
  ProtocolSupport.Reservation := False;
  ProtocolSupport.Teach_Learn := False;
  ProtocolSupport.Display := False;
  ProtocolSupport.Identification := False;
  ProtocolSupport.Valid := True;

  // When the node ID is generated the defined events will be generated from the
  // NodeID + StartIndex and incremented up to Count - 1
  EventsConsumed.AutoGenerate.Enable := True;
  EventsConsumed.AutoGenerate.Count := 10;
  EventsConsumed.AutoGenerate.StartIndex := 0;
  EventsConsumed.AutoGenerate.DefaultState := evs_InValid;

  // When the node ID is generated the defined events will be generated from the
  // NodeID + StartIndex and incremented up to Count - 1
  EventsProduced.AutoGenerate.Enable := True;
  EventsProduced.AutoGenerate.Count := 10;
  EventsProduced.AutoGenerate.StartIndex := 0;
  EventsProduced.AutoGenerate.DefaultState := evs_InValid;

  Configuration.FilePath := GetSettingsPath + 'configuration.dat';
  Configuration.Valid := True;

  // Load a CDI XML file from the same folder that the Setting.ini is stored
  // Also sync up the SNIP with this data as well
  CDI.LoadFromXml( GetSettingsPath + 'example_cdi.xml', SimpleNodeInfo);

  // Setup the Configuraion Memory Options:
  ConfigMemOptions.HighSpace := MSI_CDI;
  ConfigMemOptions.LowSpace := MSI_ACDI_USER;
  ConfigMemOptions.SupportACDIMfgRead := False;
  ConfigMemOptions.SupportACDIUserRead := False;
  ConfigMemOptions.SupportACDIUserWrite := False;
  ConfigMemOptions.UnAlignedReads := True;
  ConfigMemOptions.UnAlignedWrites := True;
  ConfigMemOptions.WriteArbitraryBytes := True;
  ConfigMemOptions.WriteLenFourBytes := True;
  ConfigMemOptions.WriteLenOneByte := True;
  ConfigMemOptions.WriteLenSixyFourBytes := True;
  ConfigMemOptions.WriteLenTwoBytes := True;
  ConfigMemOptions.WriteStream := False;
  ConfigMemOptions.WriteUnderMask := False;
  ConfigMemOptions.Valid := True;

  // Setup the Configuration Memory Addres Space Information
  ConfigMemAddressSpaceInfo.Add(MSI_CDI, True, True, True, $00000000, $FFFFFFFF);
  ConfigMemAddressSpaceInfo.Add(MSI_ALL, True, True, True, $00000000, $FFFFFFFF);
  ConfigMemAddressSpaceInfo.Add(MSI_CONFIG, True, False, True, $00000000, $FFFFFFFF);
  ConfigMemAddressSpaceInfo.Add(MSI_ACDI_MFG, False, True, True, $00000000, $FFFFFFFF);      // We don't support ACDI in this object
  ConfigMemAddressSpaceInfo.Add(MSI_ACDI_USER, False, False, True, $00000000, $FFFFFFFF);    // We don't support ACDI in this object
  ConfigMemAddressSpaceInfo.Valid := True;
end;

{ TFormTemplate }

procedure TFormTemplate.ActionComPortConnectExecute(Sender: TObject);
begin
  if ActionComPortConnect.Checked then
  begin
    ActionEthenetClientConnect.Checked := False;
    ActionEthernetServerConnect.Checked := False;
    ActionEthenetClientConnect.Enabled := False;
    ActionEthernetServerConnect.Enabled := False;
    LccComPort.OpenComPortWithLccSettings;
  end else
  begin
    LccComPort.CloseComPort(nil);
    ActionEthenetClientConnect.Enabled := True;
    ActionEthernetServerConnect.Enabled := True;
    ActionComPortConnect.Enabled := True;
  end;
end;

procedure TFormTemplate.ActionEthenetClientConnectExecute(Sender: TObject);
begin
  if ActionEthenetClientConnect.Checked then
  begin
    ActionEthernetServerConnect.Checked := False;
    ActionComPortConnect.Checked := False;
    ActionComPortConnect.Enabled := False;
    ActionEthernetServerConnect.Enabled := False;
    LccEthernetClient.OpenConnectionWithLccSettings;
  end else
  begin
    LccEthernetClient.CloseConnection(nil);
    ActionEthenetClientConnect.Enabled := True;
    ActionEthernetServerConnect.Enabled := True;
    ActionComPortConnect.Enabled := True;
  end;
end;

procedure TFormTemplate.ActionEthernetServerConnectExecute(Sender: TObject);
begin
  if ActionEthernetServerConnect.Checked then
  begin
    ActionEthenetClientConnect.Checked := False;
    ActionComPortConnect.Checked := False;
    ActionEthenetClientConnect.Enabled := False;
    ActionComPortConnect.Enabled := False;
    LccEthernetServer.OpenConnectionWithLccSettings;
  end else
  begin
    LccEthernetServer.CloseConnection(nil);
    ActionEthenetClientConnect.Enabled := True;
    ActionEthernetServerConnect.Enabled := True;
    ActionComPortConnect.Enabled := True;
  end;
end;

procedure TFormTemplate.ActionLccLoginExecute(Sender: TObject);
begin
  LccNodeManager.Enabled := ActionLccLogin.Checked;
  if not LccNodeManager.Enabled then
    StatusBarMain.Panels[1].Text := 'Disconnected';
  ButtonCreateVirtualNodes.Enabled := LccNodeManager.Enabled;
end;

procedure TFormTemplate.ActionMsgTraceExecute(Sender: TObject);
begin
  if ActionMsgTrace.Checked then
  begin
    FormLogging.FrameLccLogging.Paused := False;
    FormLogging.Show
  end else
  begin
    FormLogging.FrameLccLogging.Paused := True;
    FormLogging.Hide
  end;
end;

procedure TFormTemplate.ActionSendGlobalVerifyNodeMsgExecute(Sender: TObject);
var
  Msg: TLccMessage;
begin
  Msg := TLccMessage.Create;
  Msg.LoadVerifyNodeID(LccNodeManager.RootNodeID, LccNodeManager.RootNodeAlias);
  LccNodeManager.SendLccMessage(Msg);
  Msg.Free
end;

procedure TFormTemplate.ActionToolsPreferenceShowMacExecute(Sender: TObject);
begin
  if FormSettings.ShowModal = mrOK then
    FormSettings.FrameLccSettings.StoreSettings;
end;

procedure TFormTemplate.ActionToolsSettingsShowWinExecute(Sender: TObject);
begin
  if FormSettings.ShowModal = mrOK then
    FormSettings.FrameLccSettings.StoreSettings;
end;

procedure TFormTemplate.ButtonCreateVirtualNodesClick(Sender: TObject);
var
  i: Int64;
begin
  LccNodeManager.ClearOwned;
  i := 0;
  while i < SpinEditVNodes.Value do
  begin
    CreateVirtualNode(i + 1);
    Inc(i);
  end;
end;

procedure TFormTemplate.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if ActionComPortConnect.Checked then
    ActionComPortConnect.Execute;
  if ActionEthenetClientConnect.Checked then
    ActionEthenetClientConnect.Execute;
  if ActionEthernetServerConnect.Checked then
    ActionEthernetServerConnect.Execute;
end;

procedure TFormTemplate.FormShow(Sender: TObject);
begin
  if not ShownOnce then
  begin
    Max_Allowed_Datagrams := 1;    // Python Compatible


    {$IFDEF DARWIN}
    OSXMenu := TMenuItem.Create(Self);  {Application menu}
    OSXMenu.Caption := #$EF#$A3#$BF;  {Unicode Apple logo char}
    MainMenu.Items.Insert(0, OSXMenu);

    AppAboutCmd := TMenuItem.Create(Self);
    AppAboutCmd.Action := ActionHelpAboutShow;
    AppAboutCmd.Caption := 'About ' + BUNDLENAME;
    OSXMenu.Add(AppAboutCmd);  {Add About as item in application menu}

    OSXSep1Cmd := TMenuItem.Create(Self);
    OSXSep1Cmd.Caption := '-';
    OSXMenu.Add(OSXSep1Cmd);

    ActionToolsPreferenceShowMac.ShortCut := ShortCut(VK_OEM_COMMA, [ssMeta]);
    OSXPrefCmd := TMenuItem.Create(Self);
    OSXPrefCmd.Action := ActionToolsPreferenceShowMac;
    OSXMenu.Add(OSXPrefCmd);
    ActionToolsSettingsShowWin.Visible := False;
    {$ELSE}
    AppAboutCmd := TMenuItem.Create(Self);
    AppAboutCmd.Action := ActionHelpAboutShow;
    MenuItemHelp.Add(AppAboutCmd);
    {$ENDIF}
    {$IFDEF Linux}
    if LccSettings.FilePath = '' then
      LccSettings.FilePath := GetSettingsPath + {PATH_LINUX_APP_FOLDER + }PATH_SETTINGS_FILE;
    {$ELSE}
    if LccSettings.FilePath = '' then
      LccSettings.FilePath := GetSettingsPath + PATH_SETTINGS_FILE;
    {$ENDIF}
    if FileExists(LccSettings.FilePath) then
      LccSettings.LoadFromFile;
    FormLogging.OnHideNotifyEvent := @OnTraceFormHideEvent;
    FormSettings.FrameLccSettings.LccSettings := LccSettings;
    LccComPort.LoggingFrame := FormLogging.FrameLccLogging;
    LccEthernetClient.LoggingFrame := FormLogging.FrameLccLogging;
    LccEthernetServer.LoggingFrame := FormLogging.FrameLccLogging;
    ActionLccLogin.Enabled := False;
    PanelAddOns.Visible := False;
    FormLogging.FrameLccLogging.Paused := True;
    ShownOnce := True;
  end;
end;

procedure TFormTemplate.LccComPortConnectionStateChange(Sender: TObject; ComPortRec: TLccComPortRec);
begin
  case ComPortRec.ConnectionState of
    ccsPortConnecting :
      begin
        StatusBarMain.Panels[0].Text := 'Connecting to ' + ComPortRec.ComPort;
      end;
    ccsPortConnected  :
      begin
        ActionLccLogin.Enabled := True;
        StatusBarMain.Panels[0].Text := 'Connected to ' + ComPortRec.ComPort;
      end;
    ccsPortDisconnecting :
      begin
        StatusBarMain.Panels[0].Text := 'Disconnecting from ' + ComPortRec.ComPort;
      end;
    ccsPortDisconnected  :
      begin
        if ActionLccLogIn.Checked then
        ActionLccLogin.Execute;
        ActionLccLogin.Enabled := False;
        StatusBarMain.Panels[0].Text := 'Disconnected';
        if ActionComPortConnect.Checked then
          ActionComPortConnect.Execute;
      end;
  end;
end;

procedure TFormTemplate.LccComPortErrorMessage(Sender: TObject; ComPortRec: TLccComPortRec);
begin
  ShowMessage('Error Connecting to ComPort: ' + ComPortRec.ComPort + ': ' + ComPortRec.MessageStr);
end;

procedure TFormTemplate.LccEthernetClientConnectionStateChange(Sender: TObject; EthernetRec: TLccEthernetRec);
begin
  case EthernetRec.ConnectionState of
  ccsClientConnecting :
    begin
      StatusBarMain.Panels[0].Text := 'Connecting to ' + EthernetRec.ListenerIP + ':' + IntToStr(EthernetRec.ListenerPort);
    end;
  ccsClientConnected  :
    begin
      ActionLccLogin.Enabled := True;
      StatusBarMain.Panels[0].Text := 'Connected to ' + EthernetRec.ListenerIP + ':' + IntToStr(EthernetRec.ListenerPort);
    end;
  ccsClientDisconnecting :
    begin
      StatusBarMain.Panels[0].Text := 'Disconnecting from ' + EthernetRec.ListenerIP + ':' + IntToStr(EthernetRec.ListenerPort);
    end;
  ccsClientDisconnected  :
    begin
      if ActionLccLogIn.Checked then
        ActionLccLogin.Execute;
      ActionLccLogin.Enabled := False;
      StatusBarMain.Panels[0].Text := 'Disconnected';
      if ActionEthenetClientConnect.Checked then
        ActionEthenetClientConnect.Execute;
    end;
  end;
end;

procedure TFormTemplate.LccEthernetClientErrorMessage(Sender: TObject; EthernetRec: TLccEthernetRec);
begin
  ShowMessage('Error Connecting to Server: ' + EthernetRec.ListenerIP + ':' + IntToStr(EthernetRec.ListenerPort) + ': ' + EthernetRec.MessageStr);
end;

procedure TFormTemplate.LccEthernetServerConnectionStateChange(Sender: TObject; EthernetRec: TLccEthernetRec);
var
  ListItem: TListItem;
  i: Integer;
begin
  case EthernetRec.ConnectionState of
  ccsListenerConnecting :
    begin
      StatusBarMain.Panels[0].Text := 'Starting Server ' + EthernetRec.ListenerIP + ':' + IntToStr(EthernetRec.ListenerPort);
    end;
  ccsListenerConnected  :
    begin
      ActionLccLogin.Enabled := True;
      PanelAddOns.Visible := True;
      StatusBarMain.Panels[0].Text := 'Server started ' + EthernetRec.ListenerIP + ':' + IntToStr(EthernetRec.ListenerPort);
    end;
  ccsListenerDisconnecting :
    begin
      StatusBarMain.Panels[0].Text := 'Stopping Server from ' + EthernetRec.ListenerIP + ':' + IntToStr(EthernetRec.ListenerPort);
    end;
  ccsListenerDisconnected  :
    begin
      if ActionLccLogIn.Checked then
        ActionLccLogin.Execute;
      ActionLccLogin.Enabled := False;
      PanelAddOns.Visible := False;
      StatusBarMain.Panels[0].Text := 'Disconnected';
      if ActionEthenetClientConnect.Checked then
        ActionEthenetClientConnect.Execute;
    end;
  ccsListenerClientConnected :
    begin
      ListItem := ListViewServerConnections.Items.Add;
      ListItem.Caption := EthernetRec.ClientIP;
      ListItem.SubItems.Add(IntToStr(EthernetRec.ClientPort));
      ListItem.SubItems.Add(EthernetRec.ListenerIP);
      ListItem.SubItems.Add(IntToStr(EthernetRec.ListenerPort));
    end;
  ccsListenerClientDisconnected :
    begin
      for i := 0 to ListViewServerConnections.Items.Count - 1 do
      begin
        ListItem := ListViewServerConnections.Items[i];
        if ListItem.Caption = EthernetRec.ClientIP then
          if ListITem.SubItems[0] = IntToStr(EthernetRec.ClientPort) then
          begin
            ListViewServerConnections.Items.Delete(i);
            Break;
          end;
      end;
    end;
  end;
end;

procedure TFormTemplate.LccNodeManagerAliasIDChanged(Sender: TObject; LccSourceNode: TLccNode);
begin
  if LccSourceNode is TMyRootNode then                                          // If it is our Root Node then save the AliasID
  begin
    if LccSettings.General.AliasIDAsVal <> LccSourceNode.AliasID then
    begin
      LccSettings.General.AliasID := '0x'+ IntToHex(LccSourceNode.AliasID, 4);
      FormSettings.FrameLccSettings.StoreSettings;
    end;
    StatusBarMain.Panels[1].Text := '0x' +IntToHex(LccSourceNode.NodeID[1], 3) + IntToHex(LccSourceNode.NodeID[0], 3) + ': 0x' + IntToHex(LccSourceNode.AliasID, 4)
  end;
  {
  if VirtualNodeCreateCount > 0 then
  begin
    CreateVirtualNode(VirtualNodeCreateCount + 1);
    Dec(FVirtualNodeCreateCount);
  end; }
end;

procedure TFormTemplate.LccNodeManagerLccGetRootNodeClass(Sender: TObject; var NodeClass: TLccOwnedNodeClass);
begin
  NodeClass := TMyRootNode;
end;

procedure TFormTemplate.LccNodeManagerNodeIDChanged(Sender: TObject; LccSourceNode: TLccNode);
var
  Temp: TNodeID;
  TempID, TempID1, TempID2: QWord;
begin
  if LccSourceNode is TMyRootNode then                                          // If it is our Root Node then set its NodeID we saved
  begin
    Temp[0] := 0;
    Temp[1] := 0;
    LccSettings.General.NodeIDAsTNodeID(Temp);
    if not EqualNodeID(Temp, LccSourceNode.NodeID, True) then
    begin
       TempID1 := QWord( LccSourceNode.NodeID[0]);
       TempID2 := QWord(LccSourceNode.NodeID[1]);
       TempID2 := TempID2 shl 24;
       TempID := TempID1 or TempID2;
       LccSettings.General.NodeID := '0x'+IntToHex(TempID, 12);
       FormSettings.FrameLccSettings.StoreSettings
    end;
    StatusBarMain.Panels[1].Text := '0x' +IntToHex(LccSourceNode.NodeID[1], 3) + IntToHex(LccSourceNode.NodeID[0], 3) + ': 0x' + IntToHex(LccSourceNode.AliasID, 4)
  end;
end;

procedure TFormTemplate.LccNodeManagerRequestMessageSend(Sender: TObject; LccMessage: TLccMessage);
begin
  // The NodeManager wants to send a message, depending on who is active send the message
  // down that wire
  if ActionComPortConnect.Checked then
    LccComPort.SendMessage(LccMessage)
  else
  if ActionEthenetClientConnect.Checked then
    LccEthernetClient.SendMessage(LccMessage)
  else
  if ActionEthernetServerConnect.Checked then
    LccEthernetServer.SendMessage(LccMessage);
end;

procedure TFormTemplate.OnTraceFormHideEvent(Sender: TObject);
begin
  if ActionMsgTrace.Visible then
    ActionMsgTrace.Execute;
end;

procedure TFormTemplate.CreateVirtualNode(Offset: Int64);
var
  ANodeID: TNodeID;
  OwnedNode: TLccOwnedNode;
begin
  ANodeID[0] := LccNodeManager.RootNode.NodeID[0];
  ANodeID[1] := LccNodeManager.RootNode.NodeID[1];
  ANodeID[0] := ANodeID[0] + Offset;
  OwnedNode := LccNodeManager.CreateOwnedNodeByClass(TLccDefaultRootNode);
  OwnedNode.LoginWithNodeID(ANodeID, False);
end;

end.

