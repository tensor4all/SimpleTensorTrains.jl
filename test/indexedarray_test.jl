@testitem "indexedarray.jl" begin
    import SimpleTensorNetworks: Index, dim, IndexedArray, indices, permute

    @testset "IndexedArray" begin
        @test_throws ArgumentError IndexedArray(ones(2, 3), [Index(2, "a")])
        @test_throws ArgumentError IndexedArray(ones(2, 3), [Index(2, "a"), Index(2, "b")])
        arr = IndexedArray(ones(2, 3), [Index(2, "a"), Index(3, "b")])
        @test indices(arr) == [Index(2, "a"), Index(3, "b")]
    end

    @testset "permutedims and permute" begin
        arr = IndexedArray(ones(2, 3), [Index(2, "a"), Index(3, "b")])

        @test indices(permutedims(arr, [2, 1])) == [Index(3, "b"), Index(2, "a")]
        @test indices(permute(arr, [Index(3, "b"), Index(2, "a")])) ==
              [Index(3, "b"), Index(2, "a")]
    end

end
