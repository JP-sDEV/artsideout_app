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

  Future<List<Installation>> getInstallations(String term) async {
    InstallationQueries queryInstallation = InstallationQueries();
    QueryResult installationsResult = await _client.query(
      QueryOptions(
        documentNode: gql(queryInstallation.getAllByTitleAndDesc(term, term)),
      ),
    );

    if (!installationsResult.hasException) {
      for (var i = 0;
          i < installationsResult.data["installations"].length;
          i++) {
        // setState(() {
        listInstallations.add(
          Installation(
            installationsResult.data["installations"][i]["title"],
            installationsResult.data["installations"][i]["desc"],
            zone: installationsResult.data["installations"][i]["zone"],
            imgURL: installationsResult.data["installations"][i]["image"] ==
                    null
                ? 'https://via.placeholder.com/350'
                : installationsResult.data["installations"][i]["image"]["url"],
            videoURL:
                installationsResult.data["installations"][i]["videoUrl"] == null
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

    return listInstallations;
  }

  Future<List<Activity>> getActivities(String term) async {
    ActivityQueries queryActivities = ActivityQueries();
    QueryResult activitiesResult = await _client.query(
      QueryOptions(
        documentNode: gql(queryActivities.getAllByTitleAndDesc(term, term)),
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
        // setState(() {
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

    return listActivities;
  }

  Future<List<Profile>> getProfiles(String term) async {
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

        // setState(() {
        listProfiles.add(Profile(profilesResult.data["profiles"][i]["name"],
            profilesResult.data["profiles"][i]["desc"],
            social: socialMap,
            type: profilesResult.data["profiles"][i]["type"] ?? "",
            installations: [],
            activities: []));
        //  });
      }
    }

    return listProfiles;
  }
}
