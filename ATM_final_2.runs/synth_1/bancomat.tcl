# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/formare_numar.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/convertor_zecimal_binar.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/ram_pin.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/formare_numar_extragere.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/intrare_cifra.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/pin_check_and_change.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/afisor.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/ram_utilizator.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/depunere.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/extragere.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/ram_bancomat.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/debouncer.vhd}
  {C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/sources_1/imports/new/bancomat.vhd}
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/constrs_1/imports/new/Basys3_Master.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Bohar Anamaria/Desktop/ATM_final_2/ATM_final_2.srcs/constrs_1/imports/new/Basys3_Master.xdc}}]


synth_design -top bancomat -part xc7a35tcpg236-1


write_checkpoint -force -noxdef bancomat.dcp

catch { report_utilization -file bancomat_utilization_synth.rpt -pb bancomat_utilization_synth.pb }
