-- Drag is additional velocity decay per second. Grip scales yaw response
-- and lateral grip. Wood reproduces the original arcade handling.
return {
    wood = { drag = 0, grip = 1 },
    napkin = { drag = 1.55, grip = 1 },
    placemat = { drag = 0, grip = 0.64 },
}
