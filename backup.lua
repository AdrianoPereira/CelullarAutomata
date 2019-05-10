function countNeighbors(cell, val)
  if val == nil then
    return #cell:getNeighborhood()
  end

  local count = 0
  forEachNeighbor(cell, function(neigh)
  if neigh.past.state == val then
    count = count + 1
  end
  end)
  return count
end

Growth = Model{
  finalTime = 100,
  dim = 50,
  people = 20,
  door = Random({min=0, max=3, step=1}):sample(),
  door2 = Random({min=1, max=50, step=1}):sample(),
  random = true,

  init = function(self)
    self.cell = Cell{
        state = Random{"empty", "people"},
        execute = function(cell)
          local count = countNeighbors(cell, "p")
        end
    }

    self.cs = CellularSpace{
      xdim = self.dim,
      instance = self.cell,
    }

    self.cs:createNeighborhood{strategy = "vonneumann"}

    self.map = Map{
      target = self.cs,
      select = "state",
      value = {"wall", "people","door","empty"},
      color = {"black", "red","green","white"}
    }

    self.timer = Timer{
      Event{action = self.cs},
      Event{action = self.map}
    }
  end
}
Growth:run()