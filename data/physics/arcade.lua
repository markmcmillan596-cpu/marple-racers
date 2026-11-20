-- Distances are pixels, time is seconds, and angles are radians.
-- Treat these defaults as read-only. Copy the table for a different setup.
return {
    marbleRadius = 15,
    driveSpeed = 420,           -- Maximum forward speed under throttle.
    acceleration = 530,         -- Pixels per second squared.
    braking = 880,
    steeringRate = 3.6,         -- Radians per second at rest.
    minimumSteeringGrip = 0.72, -- Steering multiplier at full speed.
    lateralDrag = 7,            -- Exponential decay per second across the heading.
    coastDrag = 0.9,            -- Exponential decay per second along the heading.
    trackBounce = 0.42,         -- Fraction of normal speed returned on impact.
    marbleBounce = 0.55,
}
