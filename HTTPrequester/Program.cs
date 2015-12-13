using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace HTTPrequester
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Console.WriteLine("Response status code: {0}.", new HttpRequest().Get(args[0]).StatusCode);
            }
            catch (Exception e)
            {
                Console.WriteLine("Could not establish a connection");
            }
        }
    }
}
