# Welcome to Your New Sitex Site!

Congratulations! Your static site is up and running with **Sitex**.

## Next Steps

Here are some things you can do to start customizing your site:

---

### 1. Create a New Page

Add a new Markdown file in the `content/pages/` directory. For example:

```
content/pages/about.md
```

Update your `sitex.yml` configuration to include the new page:

```yaml
pages:
  - title: "Home"
    file: "content/pages/home.md"
    url: "/"
  - title: "About"
    file: "content/pages/about.md"
    url: "/about"
```

---

### 2. Write a Blog Post

Add a Markdown file in the `content/posts/` directory. For example:

```
content/posts/2024-06-01-my-first-post.md
```

Include front matter at the top of your post:

```yaml
---
title: "My First Post"
date: 2024-06-01
tags: [welcome, sitex]
---
```

---

### 3. Build and Preview

- Run `mix sitex.build` to generate your site.
- Run `mix sitex.serve` to preview it locally.

---

For more details, check the documentation or the README file. Happy publishing!
