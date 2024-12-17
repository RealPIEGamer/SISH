-- ISH Protocol (client)

-- Get the side of the modem
write("modem side = ")
modem_side = peripheral.find("modem") -- modified so it doesnt as so many damn questions, just input hostname and RUNNNNN
write("Hostname = ")
hostname = "insert host here" -- this way if you run this as startup you can just plug and play
protocol = "SISH"

-- Check modem
print("Checking modem...")
local modem = peripheral.wrap(modem_side)
if modem.isWireless() then
  print("Connected")
else
  print("Connected - Wired Only")
end

-- Check if rednet is open
print("Starting SISH v1.0 - Opening RedNet" .. tostring(rednet.isOpen(modem_side)))
if not rednet.isOpen(modem_side) then
  -- Open rednet
  rednet.open(modem_side)
end

-- Register hostname
print("Registering hostname " .. hostname .. " on protocol " .. protocol)
rednet.host(protocol, hostname)

-- ~Client Specific code~

-- Get the ID of the slave
write("Enter device ID for connection: ")
slave = io.read()
slaveID = rednet.lookup(protocol, slave)

while true do
  write("<sish@" .. slave .. "> ")
  remoteCmd = io.read()
  if remoteCmd == "exit" then
    break
  end
  args = {}
  for arg in remoteCmd:gmatch("%w+") do
    table.insert(args, arg)
  end
  rednet.send(slaveID, args, protocol)
  senderID, recvMsg, protocol = rednet.receive(protocol, 6000)
  if (senderID == slaveID and recvMsg) then
    print("Success.")
  else
    print("ERROR: Could not Connect.")
  end
end

rednet.close()