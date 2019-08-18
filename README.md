# Extra Pakete
## Highlights.jl

Die Version von Highlights.jl muss bis zum Merge von 
- JuliaDocs/Highlights.jl#34
- JuliaDocs/Highlights.jl#30
extra geladen werden:

```
Julia-Skriptum) pkg> add https://github.com/sebastianpech/Highlights.jl#JuliaSkriptum
```

## Weave.jl
Erst wenn die beiden PRs von Highlights.jl gemerged sind, ist es sinnvoll einen PR bei
Weave.jl zu machen. In der Zwischenzeit kann das Paket mit

```
(Julia-Skriptum) pkg> add https://github.com/sebastianpech/Weave.jl
```

geladen werden.

# Erzeugen

```
julia make.jl [Datei1.jmd[ Datei2.jmd]]
```
