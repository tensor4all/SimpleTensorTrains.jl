@testitem "index.jl" begin
    import SimpleTensorNetworks: Index, dim

    @testset "Index" begin
        @test Index(2, "a") isa Index
        @test dim(Index(2, "a")) == 2
    end

    @testset "Index (equality and inequality)" begin
        @test Index(2, "a") == Index(2, "a")
        @test Index(2, "a") != Index(3, "a")
        @test Index(2, "a") != Index(2, "b")
    end
end