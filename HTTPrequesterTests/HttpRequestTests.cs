using Microsoft.VisualStudio.TestTools.UnitTesting;
using HTTPrequester;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HTTPrequester.Tests
{
    [TestClass()]
    public class HttpRequestTests
    {

        [TestMethod()]
        public void GetTest()
        {
            Assert.IsNotNull(new HttpRequest().Get("http://145.24.222.160/DataFlowWebservice/api/positions?unitid=357566000058106"));
        }
    }
}