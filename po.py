import lldb

def print_to_file(debugger, command, result, dict):
  f=open("tmp1.txt","w")
  debugger.SetOutputFileHandle(f,True);
  command = "print Index"
  debugger.HandleCommand(command)

def __lldb_init_module (debugger, dict):
  debugger.HandleCommand('command script add -f po.print_to_file print_to_file ')

