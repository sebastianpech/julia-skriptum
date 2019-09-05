# Extra Pakete
## Highlights.jl

PRs Highlights.jl:
 
- [x] [Fix repl_splitter for first char in newline being non-ascii](https://github.com/JuliaDocs/Highlights.jl/pull/34)
- [ ] [Fix LaTeX escaping in text nodes and add unicode conversion](https://github.com/JuliaDocs/Highlights.jl/pull/30)

Installation:

```
(Julia-Skriptum) pkg> add https://github.com/sebastianpech/Highlights.jl#JuliaSkriptum
```

## Weave.jl

Erst wenn die beiden PRs von Highlights.jl gemerged sind, ist es sinnvoll einen PR bei
Weave.jl zu machen.

PRs Weave.jl:

- [x] [Fix displayed output produced by capture_output](https://github.com/JunoLab/Weave.jl/pull/239)
- [ ] [Improve usage of different figure environments in latex](https://github.com/JunoLab/Weave.jl/pull/241)
- [ ] [Add argument to weave function to disable unicode escape](https://github.com/JunoLab/Weave.jl/pull/244)

Installation:

```
(Julia-Skriptum) pkg> add https://github.com/sebastianpech/Weave.jl#JuliaSkriptum
```

geladen werden.

# Erzeugen

```
julia make.jl [Datei1.jmd[ Datei2.jmd]]
```
