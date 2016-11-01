class Loader {
  int lastTime;
  int interval;
  String url;
  JSONObject data;
  Loader() {
    this.interval = 60*1000; // interval between request is 60*1000 ms
    this.url = "http://54.235.200.47/tower/2016-10-15";
  }
  void refresh() {
    this.lastTime = millis();
    this.data = loadJSONObject(this.url);
    if(this.data != null) {
      JSONArray entries = this.data.getJSONArray("results");
      if(entries != null && entries.size() > 0) {
        JSONObject lastEntry = entries.getJSONObject(entries.size() - 1);
        
        float wind_speed_mph = lastEntry.getFloat("wind_speed_mph", 0);
        flock.updateFlowSpeed(wind_speed_mph);
          
        int wind_direction_deg = lastEntry.getInt("wind_direction_deg", 0);
        flock.updateFlowDirection(wind_direction_deg);
        println("[Loader] wind speed", wind_speed_mph, "dir", wind_direction_deg);
      }
    }
  }
}