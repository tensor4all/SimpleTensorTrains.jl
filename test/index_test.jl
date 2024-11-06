@testitem "index.jl" begin
    import SimpleTensorNetworks: Index, dim, isunique

    @testset "Index" begin
        @test Index(2, "a") isa Index
        @test dim(Index(2, "a")) == 2
    end

    @testset "Index (equality and inequality)" begin
        @test Index(2, "a") == Index(2, "a")
        @test Index(2, "a") != Index(3, "a")
        @test Index(2, "a") != Index(2, "b")
    end

    @testset "isunique" begin
        @test isunique([Index(2, "a"), Index(2, "a")]) == false
        @test isunique([Index(2, "a"), Index(3, "b")])
    end
end
