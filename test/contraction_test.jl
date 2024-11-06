@testitem "contraction.jl" begin
    using Random
    import SimpleTensorNetworks: Index, dim, IndexedArray, contract

    @testset "two matrices" begin
        Random.seed!(1234)
        a = IndexedArray(rand(2, 3), [Index(2, "a"), Index(3, "b")])
        b = IndexedArray(rand(3, 4), [Index(3, "b"), Index(4, "c")])

        ab = contract(a, b)
        @test ab.data ≈ a.data * b.data
    end

    @testset "two matrices (transpose)" begin
        Random.seed!(1234)
        a = IndexedArray(rand(2, 3), [Index(2, "a"), Index(3, "b")])
        b = IndexedArray(rand(4, 3), [Index(4, "c"), Index(3, "b")])

        ab = contract(a, b)
        @test ab.data ≈ a.data * transpose(b.data)
    end

    @testset "more than matrices" begin
        Random.seed!(1234)
        a = IndexedArray(rand(2, 3, 4), [Index(2, "a"), Index(3, "b"), Index(4, "c")])
        b = IndexedArray(rand(4, 5, 6), [Index(4, "c"), Index(5, "d"), Index(6, "e")])

        ab = contract(a, b)
        @test ab.data ≈
              reshape(reshape(a.data, 2 * 3, 4) * reshape(b.data, 4, 5 * 6), 2, 3, 5, 6)
    end


end
