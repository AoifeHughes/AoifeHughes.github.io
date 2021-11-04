---
title: "Visualising World Temperature Data"
date: 2021-11-04T00:57:10+01:00
draft: False
comments: false
images:
---

I like to start with the end result of a project, just to show if this is what you're looking for before you read:

{{< rawhtml >}}
    <iframe src="/subfiles/temp.html" style="height: 700px; width: 100%;"></iframe>
{{< /rawhtml >}}

Some caveats: 
- These data are limited to what a 10 second google search yielded (I found it on Kaggle)
- Data are approximately matched to country codes in order to streamline things
- Year range of data is very limited
- Code is written in an obtuse way in order to make clear what is happening
  - There is little need for multiple lists matching data codes for example
- Some countries are missing data, easily solved with better country code matching and a better data source

Libraries required for this:
- pandas
- plotly
- numpy (probably)
- pycountry (because data source lacked these codes that plotly uses)

With proper data, this should really be a country agnostic plot. I'll update this when I have time to find data...

Okay, so this pretty much works like any data analysis/visualization. First we load in the data,

{{< highlight python >}}
import plotly.graph_objects as go
import pandas as pd

df = pd.read_csv('temp_data.csv').melt(id_vars=['year'], var_name='country', value_name='temperature')
{{< / highlight >}}

, because the data are column based we just have to melt it so that each country has a year and a temperature per row.

Using pycountry we can create a dictionary to match up country names in our data to their codes used in plotting per country,

{{< highlight python >}}
import pycountry
keys = [list(pycountry.countries)[i].alpha_3 for i in range(len(pycountry.countries))]
names = [list(pycountry.countries)[i].name for i in range(len(pycountry.countries))]
conv = { v:k for k,v in zip(keys,names) }
def match_name(x):
    try:
        return conv[x]
    except KeyError as e:
        for  n in names:
            if x in n:
                return conv[n]
        return 'N/A'
df['codes'] = df.apply(lambda x: match_name(x['country']), axis=1)
{{< / highlight >}}

Finally, using plotly sliders, we can just create a Choropleth plot for each year, set it to not being visable and create a master figure out of them all. 

And thats that. 

{{< highlight python >}}
years = df['year'].unique()
years.sort()
years_sliders = []

for year in years:
    tdf = df[df['year'] == year]

    years_sliders.append(go.Choropleth(
        visible=False,
        locations = tdf['codes'],
        z = tdf['temperature'],
        text = tdf['country'],
        colorscale = 'RdBu',
        autocolorscale=True,
        reversescale=False,
        marker_line_color='darkgray',
        marker_line_width=0.5,
        colorbar_tickprefix = 'C',
        colorbar_title = 'Temperature',
        zmin=-df['temperature'].min(), zmax=df['temperature'].max()
    ))

fig = go.Figure(data=years_sliders)

steps = []
for i in range(len(years)):
    step = dict(
        method="update",
        args=[{"visible": [False] * len(fig.data)},
              {"title": "Year: " + str(years[i])}],
              label=str(years[i])  # layout attribute
    )
    step["args"][0]["visible"][i] = True  # Toggle i'th trace to "visible"
    steps.append(step)

sliders = [dict(
    active=len(years),
    currentvalue={"prefix": "Steps: "},
    pad={"t": 50},
    steps=steps,
)]

geo=dict(
        showframe=False,
        showcoastlines=False,
        projection_type='orthographic'
    )
fig.update_layout(
    sliders=sliders,
    geo=geo
)
fig.data[0].visible = True

fig.show()
{{< / highlight >}}