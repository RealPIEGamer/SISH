-- ISH Protocol (daemon)

-- Get the side of the modem
write("modem side = ")
modem_side = peripheral.find("modem")
write("Hostname = ")
hostname = "insert host here" -- this way if you run this as startup you can just plug and play
protocol = "SISH"
otm = false -- Output To Monitor
monitor = peripheral.wrap("side with monitor")
bmc = false -- Blacklist Monitor Commands

-- Check the modem
local modem = peripheral.wrap(modem_side)
wireless = modem.isWireless()
if wireless then
  print("Connected")
else
  print("Connected - Wired Only")
end

-- Check if rednet is open
print("Connected to RedNet")
if not rednet.isOpen(modem_side) then
  -- Open rednet
  rednet.open(modem_side)
end

-- Register hostname
print("Registering hostname " .. hostname .. " on protocol " .. protocol)
rednet.host(protocol, hostname)

-- ~Daemon Specific code~
print("SISH Activated")
while true do
  senderID, args, protocol = rednet.receive(protocol, 600)
  for i,v in ipairs(args) do
    write(v .. " ")
  end
  if bmc == true then
    if string.find(args, "monitor") not nil then
      print("The administrator has blocked commands with \"monitor\" in them")
      break()
  else
      if args[2] == nil then
        result = shell.run(args[1])
        rednet.send(senderID, result, protocol)
      elseif args[2] ~= nil then
      if args[3] == nil then
        resutl = shell.run(args[1], args[2])
        rednet.send(senderID, result, protocol)
      elseif args[4] == nil then
        result = shell.run(args[1], args[2], args[3])
        rednet.send(senderID, result, protocol)
      end
  else
    result = shell.run(args[1])
    rednet.send(senderID, result, protocol)
  end
    end
  end
end

rednet.close()
