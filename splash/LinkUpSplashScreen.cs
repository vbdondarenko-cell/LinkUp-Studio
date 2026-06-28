/*
 * LinkUp Studio Splash Screen
 * A beautiful loading screen for Windows startup
 * 
 * Build: csc LinkUpSplashScreen.cs -r:System.Windows.Forms.dll -r:System.Drawing.dll
 * Or use in Visual Studio
 */

using System;
using System.Drawing;
using System.Windows.Forms;
using System.Drawing.Drawing2D;

namespace LinkUpStudio
{
    class SplashScreen : Form
    {
        private Timer animationTimer;
        private int animationStep = 0;
        private int fadeStep = 0;
        private float opacity = 0f;
        private bool isFadingOut = false;
        
        // Logo blocks animation
        private Rectangle[] blockRects;
        private float[] blockOpacities;
        private float[] blockScales;
        
        // Loading bar
        private int loadingProgress = 0;
        
        // Status text
        private string[] statusMessages = {
            "Initializing...",
            "Loading fonts...",
            "Applying theme...",
            "Configuring terminal...",
            "Loading extensions...",
            "Syncing settings...",
            "Ready!"
        };
        private int currentStatus = 0;
        
        // Colors (GitHub Dark)
        private Color bgCanvas = Color.FromArgb(13, 17, 23);
        private Color bgSurface = Color.FromArgb(22, 27, 34);
        private Color accentBlue = Color.FromArgb(88, 166, 255);
        private Color accentPurple = Color.FromArgb(163, 113, 247);
        private Color textPrimary = Color.FromArgb(230, 237, 243);
        private Color textSecondary = Color.FromArgb(139, 148, 158);
        private Color borderDefault = Color.FromArgb(48, 54, 61);
        
        public SplashScreen()
        {
            // Form setup
            this.FormBorderStyle = FormBorderStyle.None;
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Size = new Size(600, 450);
            this.BackColor = bgCanvas;
            this.DoubleBuffered = true;
            this.TopMost = true;
            
            // Initialize logo animation
            blockRects = new Rectangle[4];
            blockOpacities = new float[4];
            blockScales = new float[4];
            
            for (int i = 0; i < 4; i++)
            {
                blockOpacities[i] = 0f;
                blockScales[i] = 0.5f;
            }
            
            // Timer for animations
            animationTimer = new Timer();
            animationTimer.Interval = 50;
            animationTimer.Tick += AnimationTimer_Tick;
            animationTimer.Start();
            
            // Handle click to close
            this.Click += (s, e) => CloseSplash();
            this.KeyDown += (s, e) => CloseSplash();
        }
        
        private void AnimationTimer_Tick(object sender, EventArgs e)
        {
            animationStep++;
            
            // Logo animation (first 1.5 seconds)
            if (animationStep < 30)
            {
                for (int i = 0; i < 4; i++)
                {
                    int delay = (i + 1) * 3;
                    if (animationStep > delay)
                    {
                        blockOpacities[i] = Math.Min(1f, blockOpacities[i] + 0.1f);
                        blockScales[i] = Math.Min(1f, blockScales[i] + 0.05f);
                    }
                }
            }
            
            // Fade in (first 0.5 seconds)
            if (animationStep < 10)
            {
                opacity = Math.Min(1f, opacity + 0.1f);
            }
            
            // Loading bar (1-5 seconds)
            if (animationStep >= 10 && loadingProgress < 100)
            {
                loadingProgress += 2;
                
                // Update status
                int newStatus = (loadingProgress / 15);
                if (newStatus != currentStatus && newStatus < statusMessages.Length)
                {
                    currentStatus = newStatus;
                }
            }
            
            // Fade out after 5 seconds
            if (animationStep > 100 && !isFadingOut)
            {
                isFadingOut = true;
            }
            
            if (isFadingOut)
            {
                opacity -= 0.05f;
                if (opacity <= 0)
                {
                    animationTimer.Stop();
                    this.Close();
                }
            }
            
            this.Invalidate();
        }
        
        private void CloseSplash()
        {
            if (!isFadingOut)
            {
                isFadingOut = true;
            }
        }
        
        protected override void OnPaint(PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.ClearTypeGridFit;
            
            // Apply opacity
            if (opacity < 1f)
            {
                g.Clear(Color.Black);
            }
            else
            {
                g.Clear(bgCanvas);
            }
            
            int centerX = this.Width / 2;
            int centerY = this.Height / 2 - 40;
            
            // Draw glow effect
            using (Brush glowBrush = new SolidBrush(Color.FromArgb((int)(30 * opacity), accentBlue)))
            {
                g.FillEllipse(glowBrush, centerX - 100, centerY - 100, 200, 200);
            }
            
            // Draw logo blocks (2x2 grid)
            int blockSize = 40;
            int gap = 8;
            int gridSize = blockSize * 2 + gap;
            int startX = centerX - gridSize / 2;
            int startY = centerY - gridSize / 2;
            
            for (int i = 0; i < 4; i++)
            {
                int row = i / 2;
                int col = i % 2;
                int x = startX + col * (blockSize + gap);
                int y = startY + row * (blockSize + gap);
                
                int size = (int)(blockSize * blockScales[i]);
                int offset = (blockSize - size) / 2;
                
                Color blockColor = i == 3 ? 
                    Color.FromArgb((int)(200 * blockOpacities[i] * opacity), accentBlue) :
                    Color.FromArgb((int)(255 * blockOpacities[i] * opacity), accentBlue);
                
                using (Brush brush = new SolidBrush(blockColor))
                {
                    // Rounded rectangle
                    GraphicsPath path = RoundedRect(x + offset, y + offset, size, size, 6);
                    g.FillPath(brush, path);
                }
            }
            
            // Draw title
            using (Font titleFont = new Font("Segoe UI", 24, FontStyle.Bold))
            using (Brush textBrush = new SolidBrush(Color.FromArgb((int)(255 * opacity), textPrimary)))
            {
                string title = "LinkUp Studio";
                SizeF titleSize = g.MeasureString(title, titleFont);
                float titleX = centerX - titleSize.Width / 2;
                float titleY = centerY + 80;
                
                // Draw "Link" in white and "Up" in accent
                using (Brush accentBrush = new SolidBrush(Color.FromArgb((int)(255 * opacity), accentBlue)))
                {
                    g.DrawString("Link", titleFont, textBrush, titleX, titleY);
                    g.DrawString("Up", titleFont, accentBrush, titleX + g.MeasureString("Link", titleFont).Width, titleY);
                }
            }
            
            // Draw tagline
            using (Font taglineFont = new Font("Segoe UI", 11))
            using (Brush taglineBrush = new SolidBrush(Color.FromArgb((int)(180 * opacity), textSecondary)))
            {
                string tagline = "Developer Workspace · GitHub Dark Theme";
                SizeF taglineSize = g.MeasureString(tagline, taglineFont);
                float taglineX = centerX - taglineSize.Width / 2;
                float taglineY = centerY + 115;
                g.DrawString(tagline, taglineFont, taglineBrush, taglineX, taglineY);
            }
            
            // Draw loading bar
            int barWidth = 280;
            int barHeight = 4;
            int barX = centerX - barWidth / 2;
            int barY = centerY + 150;
            
            // Background
            using (Brush barBgBrush = new SolidBrush(bgSurface))
            using (Pen borderPen = new Pen(borderDefault))
            {
                g.FillRectangle(barBgBrush, barX, barY, barWidth, barHeight);
                g.DrawRectangle(borderPen, barX, barY, barWidth, barHeight);
            }
            
            // Progress
            if (loadingProgress > 0)
            {
                using (Brush progressBrush = new LinearGradientBrush(
                    new Rectangle(barX, barY, loadingProgress * barWidth / 100, barHeight),
                    accentBlue,
                    accentPurple,
                    LinearGradientMode.Horizontal))
                {
                    g.FillRectangle(progressBrush, barX + 1, barY + 1, (loadingProgress * (barWidth - 2)) / 100, barHeight - 2);
                }
            }
            
            // Status text
            using (Font statusFont = new Font("Consolas", 10))
            using (Brush statusBrush = new SolidBrush(Color.FromArgb((int)(180 * opacity), textSecondary)))
            {
                string status = statusMessages[Math.Min(currentStatus, statusMessages.Length - 1)];
                float statusX = barX;
                float statusY = barY + 15;
                g.DrawString(status, statusFont, statusBrush, statusX, statusY);
                
                // Progress percentage
                string progress = loadingProgress + "%";
                float progressX = barX + barWidth - 40;
                g.DrawString(progress, statusFont, statusBrush, progressX, statusY);
            }
            
            // Draw version
            using (Font versionFont = new Font("Segoe UI", 9))
            using (Brush versionBrush = new SolidBrush(Color.FromArgb((int)(150 * opacity), textSecondary)))
            {
                string version = "v1.0.0";
                float versionX = this.Width - 80;
                float versionY = this.Height - 40;
                g.DrawString(version, versionFont, versionBrush, versionX, versionY);
            }
        }
        
        private GraphicsPath RoundedRect(int x, int y, int width, int height, int radius)
        {
            GraphicsPath path = new GraphicsPath();
            path.AddArc(x, y, radius, radius, 180, 90);
            path.AddArc(x + width - radius, y, radius, radius, 270, 90);
            path.AddArc(x + width - radius, y + height - radius, radius, radius, 0, 90);
            path.AddArc(x, y + height - radius, radius, radius, 90, 90);
            path.CloseFigure();
            return path;
        }
        
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new SplashScreen());
        }
    }
}