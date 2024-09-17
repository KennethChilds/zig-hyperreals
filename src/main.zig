const std = @import("std");

// Define a struct to represent a hyperreal number
// Hyperreal numbers extend real numbers to include infinitesimals and infinities
const Hyperreal = struct {
    // A hyperreal number is represented as a + bε, where:
    // 'a' is the real part (a standard real number)
    real: f64,
    // 'b' is the coefficient of the infinitesimal part
    // ε represents an infinitesimal value (conceptually smaller than any positive real number but larger than zero)
    infinitesimal: f64,

    // Constructor function to create a new Hyperreal number
    pub fn init(real: f64, infinitesimal: f64) Hyperreal {
        return Hyperreal{ .real = real, .infinitesimal = infinitesimal };
    }

    // Addition operation for hyperreal numbers
    // (a + bε) + (c + dε) = (a + c) + (b + d)ε
    pub fn add(self: Hyperreal, other: Hyperreal) Hyperreal {
        return Hyperreal.init(self.real + other.real, self.infinitesimal + other.infinitesimal);
    }

    // Subtraction operation for hyperreal numbers
    // (a + bε) - (c + dε) = (a - c) + (b - d)ε
    pub fn sub(self: Hyperreal, other: Hyperreal) Hyperreal {
        return Hyperreal.init(self.real - other.real, self.infinitesimal - other.infinitesimal);
    }

    // Multiplication operation for hyperreal numbers
    // (a + bε) * (c + dε) = ac + (ad + bc)ε + bdε²
    // We omit the ε² term as it's considered negligible compared to ε
    pub fn mul(self: Hyperreal, other: Hyperreal) Hyperreal {
        return Hyperreal.init(self.real * other.real, self.real * other.infinitesimal + self.infinitesimal * other.real);
    }

    // Division operation for hyperreal numbers
    // (a + bε) / (c + dε) ≈ (a/c) + ((bc - ad)/(c^2))ε
    // This is an approximation that ignores higher-order infinitesimals
    pub fn div(self: Hyperreal, other: Hyperreal) Hyperreal {
        const real_part = self.real / other.real;
        const infinitesimal_part = (self.infinitesimal * other.real - self.real * other.infinitesimal) / (other.real * other.real);
        return Hyperreal.init(real_part, infinitesimal_part);
    }

    // Custom formatting function for Hyperreal numbers
    // This is used when printing Hyperreal values
    pub fn format(self: Hyperreal, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        // fmt and options are unused in this simple implementation
        _ = fmt;
        _ = options;
        // Print the number in the form "a + bε"
        try writer.print("{d} + {d}ε", .{ self.real, self.infinitesimal });
    }
};

// Main function of the program
pub fn main() !void {
    // Get a writer for the standard output, which we'll use for printing
    const stdout = std.io.getStdOut().writer();

    // Create two Hyperreal numbers
    const a = Hyperreal.init(3, 1); // Represents 3 + ε
    const b = Hyperreal.init(2, 0.5); // Represents 2 + 0.5ε

    // Perform addition, subtraction, multiplication, and division on the hyperreal numbers
    const sum = a.add(b); // (3 + ε) + (2 + 0.5ε) = 5 + 1.5ε
    const difference = a.sub(b); // (3 + ε) - (2 + 0.5ε) = 1 + 0.5ε
    const product = a.mul(b); // (3 + ε) * (2 + 0.5ε) = 6 + 2.5ε
    const quotient = a.div(b); // (3 + ε) / (2 + 0.5ε) ≈ 1.5 + 0.125ε

    // Print the results
    // The `try` keyword is used because `print` may return an error
    // The `{}` in the format string is replaced by the corresponding value in the tuple `.{...}`
    try stdout.print("a = {}\n", .{a});
    try stdout.print("b = {}\n", .{b});
    try stdout.print("a + b = {}\n", .{sum});
    try stdout.print("a - b = {}\n", .{difference});
    try stdout.print("a * b = {}\n", .{product});
    try stdout.print("a / b = {}\n", .{quotient});
}

// Note: This is a simplified representation of hyperreal numbers.
// Hyperreal numbers extend real numbers to include infinitesimals and infinities,
// allowing for rigorous treatment of limits and infinitesimal calculus.
// This implementation demonstrates the basic concept in code.
