namespace PracticaBootCamp.Areas.Bcri.Models
{
    public class GridModel
    {

        public long RepositoryId { get; set; }
        public long RepositoryConfigId { get; set; }
        public string EntityName { get; set; }

        public string GridId { get; set; }


        public bool ServerSide { get; set; }
        public bool Editable { get; set; } = true;
        public bool Exportable { get; set; }

    }
}
