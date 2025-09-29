@testitem "contraction.jl" begin
    import SimpleTensorNetworks: SimpleTensorTrain, contract, dist
    import ITensors: ITensors, ITensor, Index, random_itensor
    import ITensorMPS
    import ITensors: Algorithm, @Algorithm_str
    import LinearAlgebra: norm
    ITensors.disable_warn_order()
    using Random

    # Test algorithms
    algs = ["densitymatrix", "fit", "zipup"]
    eps = Dict("densitymatrix" => 1e-6, "fit" => 1e-12, "zipup" => 1e-12)
    linkdims = 3
    R = 5

    # Helper function to create random MPO with custom sites structure
    function _random_mpo(sites::Vector{Vector{Index{T}}}; linkdims = 1) where {T}
        _random_mpo(Random.GLOBAL_RNG, sites; linkdims = linkdims)
    end

    function _random_mpo(rng, sites::Vector{Vector{Index{T}}}; linkdims = 1) where {T}
        N = length(sites)
        links = [Index(linkdims, "Link,n=$n") for n = 1:N-1]
        M = ITensorMPS.MPO(N)
        M[1] = random_itensor(rng, sites[1]..., links[1])
        M[N] = random_itensor(rng, links[N-1], sites[N]...)
        for n = 2:N-1
            M[n] = random_itensor(rng, links[n-1], sites[n]..., links[n])
        end
        return M
    end

    function relative_error(tt1::SimpleTensorTrain, tt2::SimpleTensorTrain)
        sites = SimpleTensorNetworks.siteinds(tt1)
        tt1_full = Array(reduce(*, tt1), sites)
        tt2_full = Array(reduce(*, tt2), sites)
        return norm(tt1_full - tt2_full) / norm(tt1_full)
    end

    for alg in algs
        @testset "MPO-MPO contraction (x-y-z) with $alg" begin
            Random.seed!(1234)

            sitesx = [Index(2, "Qubit,x=$n") for n = 1:R]
            sitesy = [Index(2, "Qubit,y=$n") for n = 1:R]
            sitesz = [Index(2, "Qubit,z=$n") for n = 1:R]

            sitesa = collect(collect.(zip(sitesx, sitesy)))
            sitesb = collect(collect.(zip(sitesy, sitesz)))
            a_mpo = _random_mpo(sitesa; linkdims = linkdims)
            b_mpo = _random_mpo(sitesb; linkdims = linkdims)
            
            # Convert to SimpleTensorTrain
            a = SimpleTensorTrain(a_mpo)
            b = SimpleTensorTrain(b_mpo)
            
            ab_ref = contract(a, b; alg = Algorithm"naive"())
            ab = contract(a, b; alg = Algorithm(alg))
            @test relative_error(ab_ref, ab) < eps[alg]
        end
    end

    for alg in algs
        @testset "MPO-MPO contraction (xk-y-z) with $alg" begin
            Random.seed!(1234)
            sitesx = [Index(2, "Qubit,x=$n") for n = 1:R]
            sitesk = [Index(2, "Qubit,k=$n") for n = 1:R]
            sitesy = [Index(2, "Qubit,y=$n") for n = 1:R]
            sitesz = [Index(2, "Qubit,z=$n") for n = 1:R]

            sitesa = collect(collect.(zip(sitesx, sitesk, sitesy)))
            sitesb = collect(collect.(zip(sitesy, sitesz)))
            a_mpo = _random_mpo(sitesa; linkdims = linkdims)
            b_mpo = _random_mpo(sitesb; linkdims = linkdims)
            
            # Convert to SimpleTensorTrain
            a = SimpleTensorTrain(a_mpo)
            b = SimpleTensorTrain(b_mpo)
            
            ab_ref = contract(a, b; alg = Algorithm"naive"())
            ab = contract(a, b; alg = Algorithm(alg))
            @test relative_error(ab_ref, ab) < eps[alg]
        end
    end

    for alg in algs
        @testset "MPO-MPO contraction (xk-y-zl) with $alg" begin
            Random.seed!(1234)
            sitesx = [Index(2, "Qubit,x=$n") for n = 1:R]
            sitesk = [Index(2, "Qubit,k=$n") for n = 1:R]
            sitesy = [Index(2, "Qubit,y=$n") for n = 1:R]
            sitesz = [Index(2, "Qubit,z=$n") for n = 1:R]
            sitesl = [Index(2, "Qubit,l=$n") for n = 1:R]

            sitesa = collect(collect.(zip(sitesx, sitesk, sitesy)))
            sitesb = collect(collect.(zip(sitesy, sitesz, sitesl)))
            a_mpo = _random_mpo(sitesa; linkdims = linkdims)
            b_mpo = _random_mpo(sitesb; linkdims = linkdims)
            
            # Convert to SimpleTensorTrain
            a = SimpleTensorTrain(a_mpo)
            b = SimpleTensorTrain(b_mpo)
            
            ab_ref = contract(a, b; alg = Algorithm"naive"())
            ab = contract(a, b; alg = Algorithm(alg))

            @test relative_error(ab_ref, ab) < eps[alg]
        end
    end

    #==
    for alg in algs
        @testset "MPO-MPO contraction (xk-ym-zl) with $alg" begin
            Random.seed!(1234)
            sitesx = [Index(2, "Qubit,x=$n") for n = 1:R]
            sitesk = [Index(2, "Qubit,k=$n") for n = 1:R]
            sitesy = [Index(2, "Qubit,y=$n") for n = 1:R]
            sitesz = [Index(2, "Qubit,z=$n") for n = 1:R]
            sitesl = [Index(2, "Qubit,l=$n") for n = 1:R]
            sitesm = [Index(2, "Qubit,m=$n") for n = 1:R]

            sitesa = collect(collect.(zip(sitesx, sitesk, sitesm, sitesy)))
            sitesb = collect(collect.(zip(sitesy, sitesm, sitesz, sitesl)))
            a_mpo = _random_mpo(sitesa; linkdims = linkdims)
            b_mpo = _random_mpo(sitesb; linkdims = linkdims)
            
            # Convert to SimpleTensorTrain
            a = SimpleTensorTrain(a_mpo)
            b = SimpleTensorTrain(b_mpo)
            
            ab_ref = contract(a, b; alg = Algorithm"naive"())
            ab = contract(a, b; alg = Algorithm(alg))
            @test relative_error(ab_ref, ab) < eps[alg]
        end
    end
    ==#
end