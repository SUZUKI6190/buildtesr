import std.conv : to;
import  std.stdio;

import std.file : readText;
import std.process : environment;
import vibe.vibe;
// WebAPIの定義
interface MyAPI {
    string getHello();
}

class MyAPIImpl : MyAPI {
    string getHello() { return "Hello World"; }
}

void anything(HTTPServerRequest req, HTTPServerResponse res)
{
	writeln("API Global Interceptor");
}

void main()
{
	auto settings = new HTTPServerSettings;
	settings.bindAddresses = ["0.0.0.0"];
	settings.port = environment.get("PORT", "8080").to!ushort;

	auto router = new URLRouter;

    // すべてのリクエストで通る前処理
    router.any("*", &anything);
	router.get("/", &showStartPage);
	router.get("/map", &showMapPage);
	router.get("/health", &showHealth);

	listenHTTP(settings, router);
	runApplication();
}

void showStartPage(HTTPServerRequest req, HTTPServerResponse res)
{
	serveHtml(res, "public/start.html");
}

void showMapPage(HTTPServerRequest req, HTTPServerResponse res)
{
	serveHtml(res, "public/map.html");
}

void showHealth(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeBody("ok", "text/plain; charset=utf-8");
}

void serveHtml(HTTPServerResponse res, string path)
{
	res.writeBody(readText(path), "text/html; charset=utf-8");
}
