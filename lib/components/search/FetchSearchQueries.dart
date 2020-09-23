// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/graphql/config.dart';
// Installation
import 'package:artsideout_app/graphql/Installation.dart';
// Activity
import 'package:artsideout_app/graphql/Activity.dart';
// Profile
import 'package:artsideout_app/graphql/Profile.dart';

class FetchResults {
  GraphQLClient _client = GraphQLConfiguration().clientToQuery();

  List<Installation> listInstallations = List<Installation>();
  List<Activity> listActivities = List<Activity>();
  List<Profile> listProfiles = List<Profile>();

  Future<List<dynamic>> getResults(
      String input, Map<String, bool> options) async {
    listInstallations = await getInstallationsByTypes(input, options);
    listActivities = await getActivitiesByTypes(input, options);
    listProfiles = await getProfilesByTypes(input, options);

    return [...listInstallations, ...listActivities, ...listProfiles];
  }

  bool checkNoResults(List<dynamic> listResults) {
    if (listResults.isEmpty) return true;
    return false;
  }

  Future<List<Installation>> getInstallationsByTypes(
      String term, Map<String, bool> types) async {
    listInstallations.clear();
    InstallationQueries queryInstallation = InstallationQueries();
    QueryResult installationsResult = await _client.query(
      QueryOptions(
        documentNode: gql(queryInstallation.getAllByTitleAndDesc(term)),
      ),
    );

    if (!installationsResult.hasException) {
      for (var i = 0;
          i < installationsResult.data["installations"].length;
          i++) {
        List<String> imgsURL = [];

        if (installationsResult.data["installations"][i]["images"] != null) {
          for (int j = 0;
              j < installationsResult.data["installations"][i]["images"].length;
              j++) {
            imgsURL.add(installationsResult.data["installations"][i]["images"]
                [j]["url"]);
          }
        }

        String installationType =
            installationsResult.data["installations"][i]["mediumType"];
        if (types[installationType] == true ||
            (installationType == null && types["Other"] == true)) {
          listInstallations.add(
            Installation(
              installationsResult.data["installations"][i]["title"],
              installationsResult.data["installations"][i]["desc"],
              zone: installationsResult.data["installations"][i]["zone"],
              imgURL: ['https://via.placeholder.com/350'],
              videoURL: installationsResult.data["installations"][i]
                          ["videoUrl"] ==
                      null
                  ? 'empty'
                  : installationsResult.data["installations"][i]["videoUrl"],
              location: {
                'latitude': installationsResult.data["installations"][i]
                            ["location"] ==
                        null
                    ? 0.0
                    : installationsResult.data["installations"][i]["location"]
                        ["latitude"],
                'longitude': installationsResult.data["installations"][i]
                            ["location"] ==
                        null
                    ? 0.0
                    : installationsResult.data["installations"][i]["location"]
                        ["longitude"],
              },
              locationRoom: installationsResult.data["installations"][i]
                  ["locationroom"],
              profiles: [],
            ),
          );
        }
      }
    }

    return listInstallations;
  }

  Future<List<Activity>> getActivitiesByTypes(
      String term, Map<String, bool> types) async {
    listActivities.clear();
    ActivityQueries queryActivities = ActivityQueries();
    QueryResult activitiesResult = await _client.query(
      QueryOptions(
        documentNode: gql(queryActivities.getAllByTitleAndDesc(term)),
      ),
    );

    if (!activitiesResult.hasException) {
      for (var i = 0; i < activitiesResult.data["activities"].length; i++) {
        String imgUrl =
            (activitiesResult.data["activities"][i]["image"] != null)
                ? activitiesResult.data["activities"][i]["image"]["url"]
                : "https://via.placeholder.com/350";

        List<Profile> profilesList = [];

        if (activitiesResult.data["activities"][i]["profile"] != null) {
          for (var j = 0;
              j < activitiesResult.data["activities"][i]["profile"].length;
              j++) {
            Map<String, String> socialMap = new Map();
            for (var key in activitiesResult
                .data["activities"][i]["profile"][j]["social"].keys) {
              socialMap[key] = activitiesResult.data["activities"][i]["profile"]
                  [j]["social"][key];
            }

            profilesList.add(Profile(
                activitiesResult.data["activities"][i]["profile"][j]["name"],
                activitiesResult.data["activities"][i]["profile"][j]["desc"],
                social: socialMap,
                type: activitiesResult.data["activities"][i]["profile"][j]
                        ["type"] ??
                    "",
                installations: [],
                activities: []));
          }
        }

        Map<String, double> location =
            (activitiesResult.data["activities"][i]["location"] != null)
                ? {
                    'latitude': activitiesResult.data["activities"][i]
                        ["location"]["latitude"],
                    'longitude': activitiesResult.data["activities"][i]
                        ["location"]["longitude"]
                  }
                : {'latitude': -1.0, 'longitude': -1.0};
        Map<String, String> time = {
          'startTime':
              activitiesResult.data["activities"][i]["startTime"] ?? "",
          'endTime': activitiesResult.data["activities"][i]["endTime"] ?? ""
        };

        String performanceType =
            activitiesResult.data["activities"][i]["performanceType"];
        if (types[performanceType] == true ||
            (performanceType == null && types["Other"] == true)) {
          listActivities.add(
            Activity(
                activitiesResult.data["activities"][i]["title"],
                activitiesResult.data["activities"][i]["desc"],
                activitiesResult.data["activities"][i]["zone"],
                imgUrl: imgUrl,
                time: time,
                location: location,
                profiles: profilesList),
          );
        }
      }
    }

    return listActivities;
  }

  Future<List<Profile>> getProfilesByTypes(
      String term, Map<String, bool> types) async {
    listProfiles.clear();
    ProfileQueries queryProfiles = ProfileQueries();
    QueryResult profilesResult = await _client.query(
      QueryOptions(
        documentNode: gql(queryProfiles.getAllByName(term)),
      ),
    );

    if (!profilesResult.hasException) {
      for (int i = 0; i < profilesResult.data["profiles"].length; i++) {
        Map<String, String> socialMap = new Map();
        for (var key in profilesResult.data["profiles"][i]["social"].keys) {
          socialMap[key] = profilesResult.data["profiles"][i]["social"][key];
        }

        String profileType = profilesResult.data["profiles"][i]["type"];
        if (types[profileType] == true ||
            (profileType == null && types["Other"] == true))
          listProfiles.add(Profile(profilesResult.data["profiles"][i]["name"],
              profilesResult.data["profiles"][i]["desc"],
              social: socialMap,
              type: profilesResult.data["profiles"][i]["type"] ?? "",
              installations: [],
              activities: []));
      }
    }

    return listProfiles;
  }
}
