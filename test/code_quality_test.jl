@testitem "Code quality (Aqua.jl)" begin
    using Test
    using Aqua

    import SimpleTensorNetworks

    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(SimpleTensorNetworks; unbound_args = false, deps_compat = false)
    end

end

@testitem "Code linting (JET.jl)" begin
    using Test
    using JET

    import SimpleTensorNetworks

    if VERSION >= v"1.9"
        @testset "Code linting (JET.jl)" begin
            JET.test_package(SimpleTensorNetworks; target_defined_modules = true)
        end
    end
end
