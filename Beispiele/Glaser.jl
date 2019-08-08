using Plots

R(d,λ) = d/λ
sd(d,μ) = μ*d

function p_sat(temp)
    if temp ≥ 0
        return 610.5 * exp((17.269 * temp)/(273.3 + temp))
    else
        return 610.5 * exp((21.875 * temp)/(265.5 + temp))
    end
end

function calc_t_p(ti,ta,p_par_i,p_par_a,Rs,sds,Ri,Ra)
    N_schicht = length(Rs)+1
    t = zeros(typeof(ti),N_schicht)
    p = zeros(typeof(p_par_i),N_schicht)
    Δt = ti-ta
    dtdR = Δt/(Ri+sum(Rs)+Ra)
    dpdsd = (p_par_i-p_par_a)/sum(sds)
    t[1] = ti-dtdR*Ri
    p[1] = p_par_i
    for sidx in 2:N_schicht
        t[sidx] = t[sidx-1]-dtdR*Rs[sidx-1]
        p_sat_i = p_sat(t[sidx])
        p_trial = p[sidx-1]-dpdsd*sds[sidx-1]
        if p_trial < p_sat_i
            p[sidx] = p_trial
        else
            p[sidx] = p_sat_i
            dpdsd = (p_sat_i-p_par_a)/sum(sds[sidx:end])
        end
    end
    @assert t[end]-dtdR*Ra ≈ ta
    @assert p[end] ≈ p_par_a
    return t,p
end

# Innen Klima
ti = 20.0
φi = 0.5
Ri = 0.130

# Außen Klima
ta = -10.0
φa = 0.8
Ra = 0.040

# Schichtaufbau
d = [0.015 , 0.1  , 0.24 , 0.02  , 0.0  , 0.04 , 0.03]
μ = [10.0  , 20.0 , 25.0 , 35.0  , 0.0  , 0.0  , 0.0]
λ = [0.51  , 0.04 , 1.3  ,   1.0 , Inf  , Inf  , Inf]

# Partialdruck innen / außen
p_par_i = φi*p_sat(ti)
p_par_a = φa*p_sat(ta)

Rs  = R.(d,λ)
sds = sd.(d,μ)

ts,p = calc_t_p(ti,ta,p_par_i,p_par_a,Rs,sds,Ri,Ra)

x = vcat(0.0,cumsum(sds)...) 

plt = plot(x,[p p_sat.(ts)],label=["P" "PS"])
plot!(plt,[x[1],x[end]],[p_par_i, p_par_a],label=["TP"],line=(:dash))
plot!(twinx(plt),x,ts,ylim=(-30,30),legend=:none,line=:red)
