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
    this.lastTime = millis();
    this.data = loadJSONObject(this.url);
    JSONArray entries = this.data.getJSONArray("results");
    JSONObject lastEntry = entries.getJSONObject(entries.size() - 1);
    float wind_speed_mph = lastEntry.getFloat("wind_speed_mph", 0);
    if(wind_speed_mph > 0)
      flock.updateMaxSpeed(wind_speed_mph);
    println("refreshed");
  }
}