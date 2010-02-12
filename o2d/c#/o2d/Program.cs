using System;

namespace o2d {
    static class Program {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] args) {
            using (MainGame game = new MainGame()) {
                game.Run();
            }
        }
    }
}

