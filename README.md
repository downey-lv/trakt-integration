<h1 align="center">Trakt Integration</h1>

<p align="center">
  <a href="https://github.com/custom-components/hacs">
    <img src="https://img.shields.io/badge/HACS-Default-orange.svg" alt="HACS" />
  </a> 
  <a href="https://github.com/dylandoamaral/trakt-integration">
    <img src="https://img.shields.io/github/v/release/dylandoamaral/trakt-integration" alt="Release" />
  </a> 
  <a href="https://github.com/dylandoamaral/trakt-integration">
    <img src="https://img.shields.io/github/last-commit/dylandoamaral/trakt-integration" alt="Last Commit" />
  </a> 
  <a href="https://www.buymeacoffee.com/dylandoamaral">
    <img src="https://img.shields.io/badge/buy%20me%20a%20coffee-donate-yellow" alt="Donate Coffee" />
  </a>
</p>

<p align="center">
  View your Trakt calendar items in <a href="https://github.com/custom-cards/upcoming-media-card">Upcoming Media Card</a> on a Home Assistant dashboard.
</p>

<p align="center">
  :warning: This is still an early release. It may not be stable and it may have bugs. :warning:<br />
  See the <a href="https://github.com/dylandoamaral/trakt-integration/issues">Issues</a> page to report a bug or to add a feature request.
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/dylandoamaral/trakt-integration/main/images/showcase.png" alt="Showcase Example" />
</p>

<p align="center">
  The image above was generated using <a href="https://github.com/custom-cards/upcoming-media-card">Upcoming Media Card</a> and <a href="https://github.com/dylandoamaral/upcoming-media-card-modification">Upcoming Media Card modification</a>.
</p>

----

## Recomendations 💡

Having the following installed in Home Assistant will help best use this integration:
- [Upcoming Media Card](https://github.com/custom-cards/upcoming-media-card)

## Installation 🏠

Installation is a multi-step process. Follow each of the following steps.

### 1. Add HACS Integration

This integration is available in [HACS](https://hacs.xyz/) (Home Assistant Community Store). Install it as follows:
- In Home Assistant, go to HACS > Integrations
- Press the **Explore & Add Repositories** button
- Search for "Trakt"
  - Note: There are two Trakt integrations.
    Choose the one with the description "A Trakt integration for Home Assistant compatible with upcoming media card".
    See [Why not use sensor.trakt?](#why-not-use-sensortrakt-)
- Press the **Install this repository in HACS** button
- Press the **Install** button

### 2. Update Configuration File

The following shows all of the integration's default settings.
Add it as a top-level key (i.e., `trakt_tv:` is not indented) in the `configuration.yaml` file:

```yaml
trakt_tv:
  language: en # Prefered language for movie/show title
  sensors:
    upcoming:
      show:
        days_to_fetch: 90 # How many days in the future you want to fetch
        max_medias: 3 # How many medias you want to fetch
      new_show:
        days_to_fetch: 90
        max_medias: 3
      premiere:
        days_to_fetch: 90
        max_medias: 3
      movie:
        days_to_fetch: 90
        max_medias: 3
      dvd:
        days_to_fetch: 90
        max_medias: 3
```

#### Integration Settings

- `language` should be an [ISO 639-1 codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)

#### Available Sensors

By default, this integration does not create any sensors.
The settings that you include in the `configuration.yaml` file determines which sensors are created.
This keeps you from having useless sensors that you don't need, such as the DVD sensor which will likely not fetch anything from the Trakt API,
but you can still use it if you want to.

There are five sensors available under the `sensors` > `upcoming` array:
- `show` for [TV Shows](https://trakt.tv/calendars/my/shows/) (actually, episodes). Creates `sensor.trakt_upcoming_shows`
- `new_show` for [New Shows](https://trakt.tv/calendars/my/new-shows/) (series premiers). Creates `sensor.trakt_upcoming_new_shows`
- `premiere` for [Season Premieres](https://trakt.tv/calendars/my/premieres/). Creates `sensor.trakt_upcoming_premieres`
- `movie` for [Movies](https://trakt.tv/calendars/my/movies/) premieres. Creates `sensor.trakt_upcoming_movies`
- `dvd` for [DVD & Blu-ray](https://trakt.tv/calendars/my/dvd/) releases. Creates `sensor.trakt_upcoming_dvds`

There are two parameters for each sensor:
- `days_to_fetch` should be a positive number for how many days to search
- `max_medias` should be a positive number for how many items to grab

#### Example

For example, adding only the following to `configuration.yaml` will create two sensors.
One with the next 10 TV episodes in the next 30 days and another with the next 5 movies coming out in the next 45 days:

```yaml
trakt_tv:
  language: en
  sensors:
    upcoming:
      show:
        days_to_fetch: 30
        max_medias: 10
      movie:
        days_to_fetch: 45
        max_medias: 5
```

### 3. Restart Home Assistant

- Confirm the `configuration.yaml` is valid in Configuration > Server Controls > Configuration validation > **Check Configuration** button
- Restart your Home Assistant server in Configuration > Server Controls > Server management > **Restart** button

Note: You will not see anything new in Home Assistant yet.

### 4. Prepare Trakt

You have to provide a `client_id` and a `client_secret` to use this integration. Get these keys with the following:
- Go to the [Trakt API Apps](https://trakt.tv/oauth/applications) page and press the **New application** button
- Fill in the **Name** (required) and **Description** (optional) fields. These fields are just for your own reference
- Fill in **Redirect uri** with one of the following
  - If you use HA Cloud: `https://<ha-cloud-remote-url>/auth/external/callback`
  - If you do not use HA Cloud: `https://<your-ha-server-address>:<port>/auth/external/callback`
- Do not enter anything in **Javascript (cors) origins** and do not select any **Permissions**
- Press the **Save app** button
- Record the displayed `client_id` and `client_secret`
  - Note: You do not need to press the **Authorize** button!

### 5. Add Home Assistant Integration

- In Home Assistant, go to Configuration > Integrations
- Press the **Add Integration** button
- Search for "Trakt" and click on it
- Enter the `client_id` and `client_secret` from Trakt
- Press the **Submit** button
- Press the **Finish** button

Depending on the options you set in the `configuration.yaml` file, the sensors may take a while to be created and populated.

### 6. Add an Upcoming Media Card

Go to your Dashboard, enable editing, and add a manual card like the following:

```yaml
type: custom:upcoming-media-card
entity: sensor.trakt_upcoming_shows
title: Upcoming Episodes
image_style: fanart
hide_empty: true
title_text: $title
line1_text: $episode
line2_text: $number
line3_text: $day, $date $time
line4_text: $empty
max: 10
```

See the [Upcoming Media Card](https://github.com/custom-cards/upcoming-media-card) page for formatting and display options to add to your card.

-----

## Additional Information ℹ️

### Why not use sensor.trakt ?

There is already another integration for Trakt, [sensor.trakt](https://github.com/custom-components/sensor.trakt). However, I decided to create my own integration for the following reasons:
- The other integration is almost never updated
- They haven't accepted my [pull request](https://github.com/custom-components/sensor.trakt/pull/58) for more than 3 months, so I modified it in my local environment to meet my needs
- This integration provides more features than the old one
  - Fetch more than 33 days (the single-query limitation on Trakt)
  - Have both the Movies and TV Shows calendars at the same time
  - Use other Trakt calendars such as Premieres, New Shows, and DVD & Blu-ray releases
- This integration doesn't depends to any other library (even though I would like to use [pydantic](https://pydantic-docs.helpmanual.io/) so much, ARGHHH!)

### Feature Requests and Contributions

Don't hesitate to [ask for features](https://github.com/dylandoamaral/trakt-integration/issues) or contribute your own [pull request](https://github.com/dylandoamaral/trakt-integration/pulls). ⭐

### For Developers

If you want to add a feature or fix a bug by yourself, follow these instructions:

1. Use [Visual Studio Code](https://github.com/microsoft/vscode) and use [dev containers](https://github.com/microsoft/vscode-dev-containers)
2. Run the `Run Home Assistant on port 9123`
3. Add the trakt integration
4. Start to develop a new feature
