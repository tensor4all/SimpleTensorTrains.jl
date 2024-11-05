using JET
import SimpleTensorNetworks

@testset "JET" begin
    if VERSION ≥ v"1.10"
        JET.test_package(SimpleTensorNetworks; target_defined_modules=true)
    end
end
