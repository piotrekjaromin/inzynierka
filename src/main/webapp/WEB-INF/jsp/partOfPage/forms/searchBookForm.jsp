
    <div class="form-inline">

      by Author:
      <input type="text" id="authorName" class="form-control" placeholder="name">
      <input type="text" id="authorSurname" class="form-control" placeholder="surname">
      <input type="number" id="authorYear" class="form-control" placeholder="bornYear">
      <button onclick="search('author')" class="btn btn-default">by author</button>
    </div>

    <div class="form-inline">

      by Title:
      <input type="text" id="bookTitle" class="form-control" placeholder="title">
      <button onclick="search('title')" class="btn btn-default">by title</button>
    </div>


    <div class="form-inline">

      by Year:
      <input type="number" id="bookYear" class="form-control" placeholder="year">
      <button onclick="search('year')" class="btn btn-default">by book year</button>
    </div>

  <button onclick="search('all')" class="btn btn-default">search</button>
