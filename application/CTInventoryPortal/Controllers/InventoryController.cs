using CTInventoryPortal.Data;
using CTInventoryPortal.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CTInventoryPortal.Controllers;

public class InventoryController : Controller
{
    private readonly InventoryDbContext _context;

    public InventoryController(InventoryDbContext context)
    {
        _context = context;
    }

    public async Task<IActionResult> Index(string? search)
    {
        IQueryable<InventoryItem> query = _context.InventoryItems
            .AsNoTracking();

        if (!string.IsNullOrWhiteSpace(search))
        {
            query = query.Where(item =>
                item.ProductName.Contains(search) ||
                item.Sku.Contains(search));
        }

        var items = await query
            .OrderBy(item => item.ProductName)
            .ToListAsync();

        ViewBag.Search = search;

        return View(items);
    }

    public IActionResult Create()
    {
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(InventoryItem item)
    {
        if (!ModelState.IsValid)
        {
            return View(item);
        }

        var skuExists = await _context.InventoryItems
            .AnyAsync(existing => existing.Sku == item.Sku);

        if (skuExists)
        {
            ModelState.AddModelError(
                nameof(item.Sku),
                "An inventory item with this SKU already exists.");

            return View(item);
        }

        item.CreatedAtUtc = DateTime.UtcNow;

        _context.InventoryItems.Add(item);
        await _context.SaveChangesAsync();

        TempData["SuccessMessage"] = "Inventory item created successfully.";

        return RedirectToAction(nameof(Index));
    }

    public async Task<IActionResult> Edit(int id)
    {
        var item = await _context.InventoryItems.FindAsync(id);

        if (item is null)
        {
            return NotFound();
        }

        return View(item);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, InventoryItem item)
    {
        if (id != item.InventoryItemId)
        {
            return BadRequest();
        }

        if (!ModelState.IsValid)
        {
            return View(item);
        }

        var duplicateSku = await _context.InventoryItems
            .AnyAsync(existing =>
                existing.Sku == item.Sku &&
                existing.InventoryItemId != item.InventoryItemId);

        if (duplicateSku)
        {
            ModelState.AddModelError(
                nameof(item.Sku),
                "An inventory item with this SKU already exists.");

            return View(item);
        }

        var existingItem = await _context.InventoryItems.FindAsync(id);

        if (existingItem is null)
        {
            return NotFound();
        }

        existingItem.ProductName = item.ProductName;
        existingItem.Sku = item.Sku;
        existingItem.Quantity = item.Quantity;
        existingItem.UnitPrice = item.UnitPrice;
        existingItem.UpdatedAtUtc = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        TempData["SuccessMessage"] = "Inventory item updated successfully.";

        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var item = await _context.InventoryItems.FindAsync(id);

        if (item is null)
        {
            return NotFound();
        }

        _context.InventoryItems.Remove(item);
        await _context.SaveChangesAsync();

        TempData["SuccessMessage"] = "Inventory item deleted successfully.";

        return RedirectToAction(nameof(Index));
    }
}
