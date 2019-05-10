FakeNews = Model{
    finalTime = 100,
    dim = 100,
    
    -- Probabilidade de 53% de começar sem opinião formada
    -- Probabilidade de 23,5% de começar acreditando em uma notícia falsa
    -- Probabilidade de 23,5% de começar acreditando em uma notícia verdadeira
    probone = 0.53,
	 probtwo = 0.235,

    init = function(self)
        self.cell = Cell{
            state = Random{neutral = self.probone, fake = self.probtwo, truth = self.probtwo},
            execute = function(cell)
                local fake = 0
					 local truth = 0

                forEachNeighbor(cell, function(_, neigh)
                    if neigh.past.state == "fake" then
                        fake = fake + 1
					     elseif neigh.past.state == "truth" then
                        truth = truth + 1
                    end
                end)

                -- Uma célula neutra com 4 vizinhas ou mais falsas vira falsa
                -- Uma célula neutra com 4 vizinhas ou mais verdadeiras vira verdadeira
					 if cell.past.state == "neutral" and fake >= 4 then
                    cell.state = "fake"
                elseif cell.past.state == "neutral" and truth >= 4 then
                    cell.state = "truth"
                
                -- Uma célula falsa com 7 ou 8 vizinhas verdadeiras vira verdadeira
                -- Uma célula falsa com mais de 5 vizinhas neutras vira neutra
                elseif cell.past.state == "fake" and truth >= 7 then
                    cell.state = "truth" 
                elseif cell.past.state == "fake" and truth > 5 then
                    cell.state = "neutral"

		          -- Uma célula verdadeira com 7 ou 8 vizinhas falsas vira falsa
                -- Uma célula verdadeira com mais de 5 vizinhas neutras vira neutra 
					 elseif cell.past.state == "truth" and fake >= 7 then
                    cell.state = "fake"	             
					 elseif cell.past.state == "truth" and fake > 5 then
                    cell.state = "neutral"
                end
            end
        }

        self.cs = CellularSpace{
            xdim = self.dim,
            instance = self.cell
        }

        self.cs:createNeighborhood{ }

        -- Cores => cinza: neutra, vermelha: falsa, verde: verdadeira 
		  self.map = Map{
            target = self.cs,
            select = "state",
            value = {"neutral", "fake", "truth"},
            color = {"gray", "red", "green"}
        }


        self.timer = Timer{
            Event{action = self.cs},
            Event{action = self.map}
        }
    end
}


fakenews = FakeNews{}

fakenews:run()
fakenews.map:save("fakenews.png")