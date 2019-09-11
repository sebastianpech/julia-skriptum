using JuliaSkriptumKontrolle

@Aufgabe "11.3.1" function gerade_ungerade(x::Int)
    if x % 2 == 0
        println("Gerade")
    else
        println("Ungerade")
    end
end

@Aufgabe "11.3.2" begin
    function read_radius()
        print("Radius eingeben: ")
        readline()
    end

    function AundU(r)
        println("A = $(round(r^2*π,digits=2))")
        println("U = $(round(2r*π,digits=2))")
    end

    function run()
        while (inp = read_radius()) != ""
            if (number = tryparse(Float64,inp)) != nothing
                AundU(number)
            else
                println("Falsche Eingabe")
            end
            println()
        end
    end
end

@Aufgabe "11.3.3" function π_mc(n::Int)
    inside = 0
    for _ in 1:n
        inside += rand()^2+rand()^2 <= 1.0
    end
    4*inside/n
end

@Aufgabe "11.3.4" function ∫(x,y)
    val = 0.0
    for i in 1:min(length(x),length(y))-1
        val += (x[i+1]-x[i])*(y[i]+y[i+1])/2
    end
    return val
end

revise()
