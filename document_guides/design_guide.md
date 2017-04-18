# Design Guide

In the `docs` folder of each project, there is design document specifying how the project achieve requirment.
For different usage, name of document should be different:

* `design.md`

   If this micro service is single usage, one document is enough.

* `admin_design.md`

  Design document for admin.

* `customer_design.md`

  Design document for customer.

## 1. Document Structure

All design documents should be `markdown` file, and the structure should be similar, here is schema:

```markdown
# Title

## 1. Basic Features
main features provided by project

## 2. Model Design
design point

## 3. Workflow
workflow list
```

## 2. Title

This is the title of design document, example: `Category Design for Admin`.

## 3. Basic Features

This part is the main features about project, a list is ok, exmaple:

```markdown
service provides following features:
* feature1
* feature2
* feature3
...
```

Usually, the features is the same as the api provided by project.

## 4. Model Design

This part is about how to design model, including `Data Model` and `View Model`.
We just need to write the special design.
At first, you should describe the special requirements about project's model in simple description, here is example:

```markdown
## 2. Model Design
There is 3 special requirements:
* special1

  describe the special requirement

* special2

  describe the special requirement

* special3

  describe the special requirement
```

And then, write the detail design about those special requirements in different paragraph, here is example:

```markdown

### 2.1 special1

detail design rules

### 2.2 special2

detail design rules

### 2.3 special3

detail design rules
```

## 5. Workflow

In this part, describe the workflow about the main features, here is exampke:

```markdown
## 3. Workdown
### 3.1 feature1

1. step1
2. step2
3. step3

### 3.2 feature1

1. step1
2. step2
3. step3


### 3.3 feature1

1. step1
2. step2
3. step3
```