# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7a35tlftg256-2L

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir E:/vivado_files/test_module/test_module.cache/wt [current_project]
set_property parent.project_path E:/vivado_files/test_module/test_module.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo e:/vivado_files/test_module/test_module.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/Buzzer.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/Buzzer_Mozart.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/Buzzer_shine.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/Compare2.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/Compare3.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/Judge2.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/Judge3.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/KEYNUM.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/KeyIn.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/MODULE_1.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/MODULE_2.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/MODULE_Adder.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/Timer.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/add10.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/get_rand1.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/get_rand2.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/keyboard.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/led_disp.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/rand1.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/rand2.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/reg_24bit.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/reg_2bit.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/reg_4bit.v
  E:/vivado_files/test_module/test_module.srcs/sources_1/new/test_top.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/vivado_files/test_module/test_module.srcs/constrs_1/new/cons.xdc
set_property used_in_implementation false [get_files E:/vivado_files/test_module/test_module.srcs/constrs_1/new/cons.xdc]


synth_design -top test_top -part xc7a35tlftg256-2L


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef test_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file test_top_utilization_synth.rpt -pb test_top_utilization_synth.pb"
