using System;
using System.Collections.Generic;

namespace Microsoft.Graph.PowerShell.Authentication.Common
{
    internal class DependencySettings
    {
        public IDictionary<string, Version> SharedDependencies { get; set; }
        public IList<string> MultiFrameworkDependencies { get; set; }
    }
}
