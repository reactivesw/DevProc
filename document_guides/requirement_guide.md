# Requirement Guide

In the `docs` folder of each project, there is requirement document specifying the business requirment of the project.
For different usage, name of document should be different:

* `requirement.md`

   if this micro service is single usage, one document is enough.

* `admin_requirement.md`

  requirement document for admin-web.

* `customer_requirement.md`

  requrement document for customer-web.

## 1. Document Structure

All requirement document is `markdown` file, and the structure should be similar, here is schema:

```markdown
# Title
introduction

## Requirement

requirement in list or different paragraph

## How to provide
Link to the api document
```

## 2. Title and introduction

* Title

  this is the title of the requirement document, exmaple: `Customer-Web Requirement on Category`.

* Introduction

  in this paragraph, write the main features of this project.

## 3. Requirement

In this park, write the requirement in detail.

If requirements can be divided to several main requirements and each requirement contains several simple and short requirements,
you need to divide main requirements and its sub-requirements into different paragraph, example:

```markdown
## Requirement

### Main-Requirement1

1. sub-requirement1
2. sub-requirement2
3. sub-requirement3

### Main-Requirement2

1. sub-requirement1
2. sub-requirement2
3. sub-requirement3
```

If requirement is simple and less(I mean it is one main requirement), I think an ordered list is fine, example:

```markdown
## Requirement

1. requirement1
2. requirement2
3. requirement3
```

## 4. How to provide

This park describes what kind of service provided by project.
Our project provides rest api, write the api document link here is ok usually.