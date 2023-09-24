---
title:  "Add Google Analytics to Jekyll"
date:   2016-07-26 09:00
categories:
---

- Sign up for new Google Analytics account using this [link](https://analytics.google.com/analytics/web/?authuser=0#provision/SignUp/).

- Paste the Google Analytics tracking code into a new file named `_includes/analytics.html` file under your Jekyll project. This step enables the tracking code template for use for all available Jekyll pages.

```
_includes/
├── analytics.html
```

- Insert {% raw %}`{% include analytics.html %}`{% endraw %} after {% raw %}`{% include head.html %}`{% endraw %} line in the `_layouts/default.html` file. This step ensures that the tracking code template will be included in all generated Jekyll pages.

{% highlight patch %}
    {% raw %}{% include head.html %}{% endraw %}
+   {% raw %}{% include analytics.html %}{% endraw %}
{% endhighlight %}

- Run `jekyll build` to generate the Jekyll site using the Google analytics template. You will notice that Google Analytics tracking code is included in the generated pages. For example, `_site/index.html`.

- Otherwise, run `jekyll serve` or `bundle exec jekyll serve` command to serve and test your site locally at `localhost:4000`.

## Credits

Read Michael Lee's [post](https://michaelsoolee.com/google-analytics-jekyll/) or Jekyll [documentation](https://jekyllrb.com/docs/configuration/) on further customizing Google analytics for Jekyll for use only in production environment.
