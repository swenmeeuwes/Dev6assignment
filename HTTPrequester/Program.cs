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
            //string url = "http://145.24.222.160/DataFlowWebservice/api/positions?unitid=357566000058106";
            foreach (var item in args)
            {
                Console.WriteLine(item);
            }

            Console.ReadLine();

            //HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

            //HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            //Stream resStream = response.GetResponseStream();

            //Console.WriteLine(resStream.Length);
        }
    }
}
