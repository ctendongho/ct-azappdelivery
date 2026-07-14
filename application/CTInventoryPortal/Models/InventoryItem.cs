using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CTInventoryPortal.Models;

public class InventoryItem
{
    public int InventoryItemId { get; set; }

    [Required]
    [StringLength(150)]
    [Display(Name = "Product name")]
    public string ProductName { get; set; } = string.Empty;

    [Required]
    [StringLength(50)]
    [Display(Name = "SKU")]
    public string Sku { get; set; } = string.Empty;

    [Required]
    [Range(0, int.MaxValue)]
    public int? Quantity { get; set; }

    [Required]
    [Range(typeof(decimal), "0", "9999999999999999.99")]
    [Column(TypeName = "decimal(18,2)")]
    [Display(Name = "Unit price")]
    public decimal? UnitPrice { get; set; }

    [Display(Name = "Created")]
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;

    [Display(Name = "Updated")]
    public DateTime? UpdatedAtUtc { get; set; }
}
