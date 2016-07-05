---
layout: default
---

{% for post in site.posts %}
{% if forloop.first %}
{% assign page = post %}
{% assign content = post.content %}
{% include post.html %}
{% endif %}
{% endfor %}

<!---
### Posts
{% for post in site.posts %}
{{ post.date | date: "%Y-%m-%d" }} - [{{ post.title }}]({{ post.url | prepend: site.baseurl }})
{% endfor %}
-->
