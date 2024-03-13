namespace SchemaMigration.Models
{
    public class ProductRating
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public Product Product { get; set; }
        public int Rating { get; set; }
    }

}
