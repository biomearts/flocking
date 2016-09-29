class Loader {
  int lastTime;
  int interval;
  String url;
  JSONObject data;
  Loader() {
    this.interval = 60*1000;
    this.url = "http://54.235.200.47/tower/2016-09-01";
  }
  void refresh() {
    println("refresh");
    this.lastTime = millis();
    this.data = loadJSONObject(this.url);
    println("loaded");
  }
}