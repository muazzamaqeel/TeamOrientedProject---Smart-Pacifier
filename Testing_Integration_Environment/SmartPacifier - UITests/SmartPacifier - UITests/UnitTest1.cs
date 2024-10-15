using Xunit;

namespace SmartPacifier___UITests
{
    public class UnitTest1
    {
        [Fact]
        public void TestStringEquality()
        {
            // Arrange
            string expected = "Hello World";
            string actual = "Hello World";
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void TestStringContains()
        {
            // Arrange
            string mainString = "Smart Pacifier Project";
            string substring = "Pacifier";

            // Act & Assert
            Assert.Contains(substring, mainString);
        }
    }
}
