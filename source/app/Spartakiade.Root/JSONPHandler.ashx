<%@ WebHandler Language="C#" Class="JSONPHandler" %>

using System;
using System.IO;
using System.Web;

public class JSONPHandler : IHttpHandler
{
	public void ProcessRequest (HttpContext context)
	{
		string callback = context.Request.QueryString["json"];
		string file = context.Request.QueryString["file"];
        
        try
		{
			context.Response.ContentType = "text/javascript";
			context.Response.AddHeader("X-Content-Type-Options", "nosniff");
			context.Response.Cache.SetLastModified(File.GetLastWriteTimeUtc(context.Server.MapPath(file)));
			context.Response.Cache.SetCacheability(HttpCacheability.Public);
			context.Response.Cache.SetSlidingExpiration(true);
			context.Response.Cache.SetExpires(DateTime.Now.AddDays(30));
			context.Response.Cache.SetMaxAge(TimeSpan.FromDays(30));
			context.Response.Cache.SetNoTransforms();
			
			if (!String.IsNullOrEmpty(callback))
			{
				//context.Response.Write("alert('hit');");
				context.Response.Write(callback + "(");
			}
			
			context.Response.TransmitFile(file);
			
			if (!String.IsNullOrEmpty(callback))
			{
				context.Response.Write(");");
			}
		}
		catch(FileNotFoundException)
		{
			context.Response.Clear();
			context.Response.StatusCode = 404;
		}
    }

    public bool IsReusable
	{
        get
		{
            return true;
        }
    }
}