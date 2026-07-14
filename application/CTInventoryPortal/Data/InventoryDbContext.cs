using CTInventoryPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace CTInventoryPortal.Data;

public class InventoryDbContext : DbContext
{
    public InventoryDbContext(DbContextOptions<InventoryDbContext> options)
        : base(options)
    {
    }

    public DbSet<InventoryItem> InventoryItems => Set<InventoryItem>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<InventoryItem>(entity =>
        {
            entity.ToTable("InventoryItems", "dbo");

            entity.HasKey(item => item.InventoryItemId);

            entity.HasIndex(item => item.Sku)
                .IsUnique();

            entity.Property(item => item.ProductName)
                .HasMaxLength(150)
                .IsRequired();

            entity.Property(item => item.Sku)
                .HasMaxLength(50)
                .IsRequired();

            entity.Property(item => item.UnitPrice)
                .HasPrecision(18, 2);

            entity.Property(item => item.CreatedAtUtc)
                .HasDefaultValueSql("SYSUTCDATETIME()");
        });
    }
}
