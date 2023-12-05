local Impl = NewImpl("Test")

function Impl:Init()
  main:LogInfo("%s initialized", self:GetName())
  self.data = {
    test = "test"
  }
end

function Impl:GetData()
  return self.data
end