{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit LCC;

interface

uses
  lcc_app_common_settings, lcc_can_message_assembler_disassembler, 
  lcc_cdi_parser, lcc_comport, lcc_defines, lcc_ethenetserver, 
  lcc_ethernetclient, lcc_gridconnect, lcc_math_float16, lcc_messages, 
  lcc_nodemanager, lcc_tcp_protocol, lcc_threaded_stringlist, 
  lcc_threadedcirculararray, lcc_utilities, lcc_common_classes, 
  lcc_nodeselector, lcc_raspberrypi_spiport, lcc_compiler_types, 
  lcc_raspberrypi_gpio_file, lcc_raspberrypi, lcc_sdn_utilities, 
  lcc_xmlutilities, lcc_mdns_singleshot, frame_lcc_logging, 
  frame_lcc_settings, lcc_websocketserver, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('lcc_app_common_settings', @lcc_app_common_settings.Register);
  RegisterUnit('lcc_cdi_parser', @lcc_cdi_parser.Register);
  RegisterUnit('lcc_comport', @lcc_comport.Register);
  RegisterUnit('lcc_ethenetserver', @lcc_ethenetserver.Register);
  RegisterUnit('lcc_ethernetclient', @lcc_ethernetclient.Register);
  RegisterUnit('lcc_nodemanager', @lcc_nodemanager.Register);
  RegisterUnit('lcc_nodeselector', @lcc_nodeselector.Register);
  RegisterUnit('lcc_raspberrypi_spiport', @lcc_raspberrypi_spiport.Register);
  RegisterUnit('lcc_sdn_utilities', @lcc_sdn_utilities.Register);
  RegisterUnit('lcc_mdns_singleshot', @lcc_mdns_singleshot.Register);
  RegisterUnit('lcc_websocketserver', @lcc_websocketserver.Register);
end;

initialization
  RegisterPackage('LCC', @Register);
end.
