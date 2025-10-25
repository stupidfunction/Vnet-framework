local Vnet = {}
Vnet.__index = Vnet

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

function Vnet.new()
	local self = setmetatable({}, Vnet)
	self.Remotes = {}
	return self
end

function Vnet:RegisterRemote(name, isFunction)
	if self.Remotes[name] then return self.Remotes[name] end
	local remote
	if isFunction then
		remote = Instance.new("RemoteFunction")
	else
		remote = Instance.new("RemoteEvent")
	end
	remote.Name = name
	remote.Parent = ReplicatedStorage
	self.Remotes[name] = remote
	return remote
end

function Vnet:GetRemote(name)
	return self.Remotes[name] or ReplicatedStorage:FindFirstChild(name)
end

function Vnet:SendToClient(player, remoteName, ...)
	local remote = self:GetRemote(remoteName)
	if remote and remote:IsA("RemoteEvent") then
		remote:FireClient(player, ...)
	end
end

function Vnet:SendToAll(remoteName, ...)
	local remote = self:GetRemote(remoteName)
	if remote and remote:IsA("RemoteEvent") then
		remote:FireAllClients(...)
	end
end

function Vnet:ReceiveFromClient(remoteName, callback)
	local remote = self:GetRemote(remoteName)
	if remote and remote:IsA("RemoteEvent") then
		remote.OnServerEvent:Connect(callback)
	elseif remote and remote:IsA("RemoteFunction") then
		remote.OnServerInvoke = callback
	end
end

return Vnet
