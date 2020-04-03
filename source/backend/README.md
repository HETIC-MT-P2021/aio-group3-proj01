# API Documentation

The API is made with [Phoenix](https://www.phoenixframework.org/) and a front-end interface also exists to present gallery content. [View more about the front-end.]()

## Summary
- [Get Started](#get-started)
- [API Reference](#api-reference)
    - [Images](#images)
    - [Categories](#categories)
    - [Tags](#tags)

## Get started

The first thing you can do when calling the API is to check if the service is running. To do so you can make a **GET** call on the `/healthcheck` route.

If you get a 200 status code with a small `.json` response everything should be allright.

---
## API Reference

### Images

Our images entities have the following properties:
|property|type|notes|
|-|-|-|
|id|auto increment||
|description|text||
|image|string|image filename|
|createdAt|datetime||
|id_category|foreign key||

> Please note thar our images are stored and received in `images/jpg` or `images/png` formats.

#### Get images
- URL

    `/images`
- Method

    `GET`
- Data params

    None
    
#### Get image by id
- URL

    `/images:id`
- Method

    `GET`
- Data params

    None
    

#### Add images
- URL

    `/images`
- Method

    `POST`
- Data params
    ```json
    {
        "id": "33",
        "description": "this is the best image ever",
        "image": "/file_path",
        "category": "sport",
        "tags": ["soccer"]
    }
    ```

    > If `category` or `tags` doen't exist, they'll be created.

#### Edit images
- URL

    `/images/:id`
- Method

    `PUT`
- Data params
    ```json
    {
        "id": "33",
        "description": "this is the worse image ever",
        "image": "/file_path",
        "category": "sport",
        "tags": ["soccer"]
    }
    ```

    > If `category` or `tags` doen't exist, they'll be created.

#### Remove images
- URL

    `/images/:id`
- Method

    `DELETE`
- Data params

    None

#### Get images by category
- URL

    `/images/categories/:id`

    > The id is the ID of the category you are looking for.
- Method

    `GET`
- Data params

    None

#### Get images by tag
- URL

    `/images/tags/:id`

    > The id is the ID of the tag you are looking for.
- Method

    `GET`
- Data params

    None

---
### Categories

Our categories entities have the following properties:
|property|type|notes|
|-|-|-|
|id|auto increment||
|name|string|`unique`|

#### Get categories
- URL

    `/categories`
- Method

    `GET`
- Data params

    None

#### Add categories
- URL

    `/categories`
- Method

    `POST`
- Data params
    ```json
    {
        "name": "sport"
    }
    ```

#### Edit categories
- URL

    `/categories/:id`
- Method

    `PUT`
- Data params
    ```json
    {
        "name": "Sport"
    }
    ```

#### Remove categories
- URL

    `/categories/:id`
- Method

    `DELETE`
- Data params

    None

---
### Tags

Our tags entities have the following properties:
|property|type|notes|
|-|-|-|
|id|auto increment||
|name|string|`unique`|

#### Get tags
- URL

    `/tags`
- Method

    `GET`
- Data params

    None

#### Add tags
- URL

    `/tags`
- Method

    `POST`
- Data params

    ```json
    {
        "name": "soccer"
    }
    ```

#### Edit tags

- URL

    `/tags/:id`
- Method

    `PUT`
- Data params
    ```json
    {
        "name": "football"
    }
    ```

#### Remove tags
- URL

    `/tags/:id`
- Method

    `DELETE`
- Data params

    None

---
