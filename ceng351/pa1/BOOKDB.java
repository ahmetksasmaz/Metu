package ceng.ceng351.bookdb;

import ceng.ceng351.bookdb.QueryResult.ResultQ1;
import ceng.ceng351.bookdb.QueryResult.ResultQ2;
import ceng.ceng351.bookdb.QueryResult.ResultQ3;
import ceng.ceng351.bookdb.QueryResult.ResultQ4;
import ceng.ceng351.bookdb.QueryResult.ResultQ5;
import ceng.ceng351.bookdb.QueryResult.ResultQ6;
import ceng.ceng351.bookdb.QueryResult.ResultQ7;
import ceng.ceng351.bookdb.QueryResult.ResultQ8;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class BOOKDB implements IBOOKDB {

    /**
     * Place your initialization code inside if required.
     *
     * <p>
     * This function will be called before all other operations. If your
     * implementation need initialization , necessary operations should be done
     * inside this function. For example, you can set your connection to the
     * database server inside this function.
     */
    /**
     * Place your initialization code inside if required.
     *
     * <p>
     * This function will be called before all other operations. If your
     * implementation need initialization , necessary operations should be done
     * inside this function. For example, you can set your connection to the
     * database server inside this function.
     */

    private static String user = "2237824"; // TODO: Your userName
    private static String password = "c728f559"; //  TODO: Your password
    private static String host = "144.122.71.65"; // host name
    private static String database = "db2237824"; // TODO: Your database name
    private static int port = 8084; // port

    private static Connection connection = null;

    public void initialize(){
      String url = "jdbc:mysql://" + host + ":" + port + "/" + database;

      try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          connection = DriverManager.getConnection(url, user, password);
      } catch (SQLException | ClassNotFoundException e) {
          e.printStackTrace();
      }
    }

    /**
     * Should create the necessary tables when called.
     *
     * @return the number of tables that are created successfully.
     */
    public int createTables(){
      String [] sql = new String[5];
      sql[0] = "CREATE TABLE   author(author_id INT, author_name VARCHAR(60), PRIMARY KEY (author_id));";
      sql[1] = "CREATE TABLE   publisher(publisher_id INT, publisher_name VARCHAR(50), PRIMARY KEY (publisher_id));";
      sql[2] = "CREATE TABLE   book(isbn CHAR(13), book_name VARCHAR(120), publisher_id INT, first_publish_year CHAR(4), page_count INT, category VARCHAR(25), rating FLOAT, PRIMARY KEY (isbn), FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id));";
      sql[3] = "CREATE TABLE   author_of(isbn CHAR(13), author_id INT, PRIMARY KEY (isbn, author_id), FOREIGN KEY (isbn) REFERENCES book(isbn), FOREIGN KEY (author_id) REFERENCES author(author_id));";
      sql[4] = "CREATE TABLE   phw1(isbn CHAR(13), book_name VARCHAR(120), rating FLOAT, PRIMARY KEY (isbn));";
      int success = 0;
      for(int i = 0; i < 5; i++){
        try {
            Statement st = connection.createStatement();
            st.executeUpdate(sql[i]); success++;
        } catch (SQLException e) {
        }
      }
      return success;
    }

    /**
     * Should drop the tables if exists when called.
     *
     * @return the number of tables are dropped successfully.
     */
    public int dropTables(){
      String [] sql = new String[5];
      sql[2] = "DROP TABLE   author;";
      sql[3] = "DROP TABLE   publisher;";
      sql[1] = "DROP TABLE   book;";
      sql[0] = "DROP TABLE   author_of;";
      sql[4] = "DROP TABLE   phw1;";
      int success = 0;
      for(int i = 0; i < 5; i++){
        try {
            Statement st = connection.createStatement();
            st.executeUpdate(sql[i]); success++;
        } catch (SQLException e) {
        }
      }
      return success;
    }

    /**
     * Should insert an array of Author into the database.
     *
     * @return Number of rows inserted successfully.
     */
    public int insertAuthor(Author[] authors){
      int success = 0;
      for(int i = 0; i < authors.length; i++){
        try {
            String sql = "INSERT INTO author VALUES("
            +authors[i].getAuthor_id()+",\""
            +authors[i].getAuthor_name()
            +"\");";
            Statement st = connection.createStatement();
            success += st.executeUpdate(sql) == 1 ? 1 : 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
      }
      return success;
    }

    /**
     * Should insert an array of Book into the database.
     *
     * @return Number of rows inserted successfully.
     */
    public int insertBook(Book[] books){
      int success = 0;
      for(int i = 0; i < books.length; i++){
        try {
            String sql = "INSERT INTO book VALUES(\""
            +books[i].getIsbn()+"\",\""
            +books[i].getBook_name()+"\","
            +books[i].getPublisher_id()+","
            +books[i].getFirst_publish_year()+","
            +books[i].getPage_count()+",\""
            +books[i].getCategory()+"\","
            +books[i].getRating()
            +");";
            Statement st = connection.createStatement();
            success += st.executeUpdate(sql) == 1 ? 1 : 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
      }
      return success;
    }

    /**
     * Should insert an array of Publisher into the database.
     *
     * @return Number of rows inserted successfully.
     */
    public int insertPublisher(Publisher[] publishers){
      int success = 0;
      for(int i = 0; i < publishers.length; i++){
        try {
            String sql = "INSERT INTO publisher VALUES("
            +publishers[i].getPublisher_id()+",\""
            +publishers[i].getPublisher_name()
            +"\");";
            Statement st = connection.createStatement();
            success += st.executeUpdate(sql) == 1 ? 1 : 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
      }
      return success;
    }

    /**
     * Should insert an array of Author_of into the database.
     *
     * @return Number of rows inserted successfully.
     */
    public int insertAuthor_of(Author_of[] author_ofs){
      int success = 0;
      for(int i = 0; i < author_ofs.length; i++){
        try {
            String sql = "INSERT INTO author_of VALUES(\""
            +author_ofs[i].getIsbn()+"\","
            +author_ofs[i].getAuthor_id()
            +");";
            Statement st = connection.createStatement();
            success += st.executeUpdate(sql) == 1 ? 1 : 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
      }
      return success;
    }

    /**
     * Should return isbn, first_publish_year, page_count and publisher_name of
     * the books which have the maximum number of pages.
     * @return QueryResult.ResultQ1[]
     */
    public QueryResult.ResultQ1[] functionQ1(){
      QueryResult.ResultQ1[] resultSet = null;
      try {
          String sql = ""
          +"SELECT B.isbn, B.first_publish_year, B.page_count, P.publisher_name "
          +"FROM book B, publisher P "
          +"WHERE B.publisher_id = P.publisher_id AND page_count = (SELECT MAX(page_count) FROM book) "
          +"ORDER BY B.isbn;";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);

          if (rs.last()){
            resultSet = new QueryResult.ResultQ1[rs.getRow()];
            rs.beforeFirst();
          }
          int i = 0;
          while (rs.next()){
            resultSet[i] = new QueryResult.ResultQ1(rs.getString(1),rs.getString(2),rs.getInt(3),rs.getString(4));
            i++;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return resultSet;
    }

    /**
     * For the publishers who have published books that were co-authored by both
     * of the given authors(author1 and author2); list publisher_id(s) and average
     * page_count(s)  of all the books these publishers have published.
     * @param author_id1
     * @param author_id2
     * @return QueryResult.ResultQ2[]
     */

    public QueryResult.ResultQ2[] functionQ2(int author_id1, int author_id2){
      QueryResult.ResultQ2[] resultSet = null;
      try {
          String sql = ""
          +"SELECT PX.publisher_id, AVG(BX.page_count) "
          +"FROM publisher PX, book BX "
          +"WHERE PX.publisher_id = BX.publisher_id AND PX.publisher_id IN "
          +"(SELECT B1.publisher_id FROM book B1, author_of AO1, book B2, author_of AO2 WHERE B1.isbn = AO1.isbn AND B2.isbn = AO2.isbn AND B1.isbn = B2.isbn AND AO1.author_id = "+author_id1+" AND AO2.author_id = "+author_id2+") "
          +"GROUP BY PX.publisher_id "
          +"ORDER BY PX.publisher_id"
          +";";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);

          if (rs.last()){
            resultSet = new QueryResult.ResultQ2[rs.getRow()];
            rs.beforeFirst();
          }
          int i = 0;
          while (rs.next()){
            resultSet[i] = new QueryResult.ResultQ2(rs.getInt(1),rs.getDouble(2));
            i++;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return resultSet;
    }

    /**
     * List book_name, category and first_publish_year of the earliest
     * published book(s) of the author(s) whose author_name is given.
     * @param author_name
     * @return QueryResult.ResultQ3[]
     */

    public QueryResult.ResultQ3[] functionQ3(String author_name){
      QueryResult.ResultQ3[] resultSet = null;
      try {
          String sql = ""
          +"SELECT BX.book_name, BX.category, BX.first_publish_year "
          +"FROM book BX, author AX, author_of AOX "
          +"WHERE BX.first_publish_year = "
          +"(SELECT MIN(B.first_publish_year) "
          +"FROM book B, author A, author_of AO "
          +"WHERE A.author_name = \""+author_name+"\" AND A.author_id = AO.author_id AND B.isbn = AO.isbn "
          +") AND AX.author_name = \""+author_name+"\" AND AX.author_id = AOX.author_id AND BX.isbn = AOX.isbn"
          +" ORDER BY BX.book_name, BX.category, BX.first_publish_year;";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);

          if (rs.last()){
            resultSet = new QueryResult.ResultQ3[rs.getRow()];
            rs.beforeFirst();
          }
          int i = 0;
          while (rs.next()){
            resultSet[i] = new QueryResult.ResultQ3(rs.getString(1),rs.getString(2),rs.getString(3));
            i++;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return resultSet;
    }

    /**
     * For publishers whose name contains at least 3 words
     * (i.e., "Koc Universitesi Yayinlari"), have published at least 3 books
     * and average rating of their books are greater than(>) 3;
     * list their publisher_id(s) and distinct category(ies) they have published.
     * PS: You may assume that each word in publisher_name is seperated by a space.
     * @return QueryResult.ResultQ4[]
     */
    public QueryResult.ResultQ4[] functionQ4(){
      QueryResult.ResultQ4[] resultSet = null;
      try {
          String sql = ""
          +"SELECT DISTINCT P.publisher_id, B.category "
          +"FROM publisher P, book B "
          +"WHERE (SELECT LENGTH(PX.publisher_name) - LENGTH(REPLACE(PX.publisher_name, ' ', '')) + 1 FROM publisher PX WHERE PX.publisher_id = P.publisher_id) >= 3 "
          +"AND (SELECT COUNT(BX.isbn) FROM book BX WHERE BX.publisher_id = P.publisher_id) >= 3 "
          +"AND (SELECT AVG(BZ.rating) FROM book BZ WHERE BZ.publisher_id = P.publisher_id) > 3 "
          +"AND B.publisher_id = P.publisher_id"
          +" ORDER BY P.publisher_id, B.category;";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);

          if (rs.last()){
            resultSet = new QueryResult.ResultQ4[rs.getRow()];
            rs.beforeFirst();
          }
          int i = 0;
          while (rs.next()){
            resultSet[i] = new QueryResult.ResultQ4(rs.getInt(1),rs.getString(2));
            i++;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return resultSet;
    }

    /**
     * List author_id and author_name of the authors who have worked with
     * all the publishers that the given author_id has worked.
     * @param author_id
     * @return QueryResult.ResultQ5[]
     */

    public QueryResult.ResultQ5[] functionQ5(int author_id){
      QueryResult.ResultQ5[] resultSet = null;
      try {
          String sql = ""
          +"SELECT A.author_id, A.author_name "
          +"FROM author A "
          +"WHERE (SELECT COUNT(PZ.publisher_id) "
          +"FROM publisher PZ "
          +"WHERE PZ.publisher_id IN "
          +"(SELECT DISTINCT BX.publisher_id "
          +"FROM book BX, author_of AOX "
          +"WHERE AOX.author_id = "+author_id+" AND AOX.isbn = BX.isbn) "
          +"AND PZ.publisher_id NOT IN "
          +"(SELECT DISTINCT BX.publisher_id "
          +"FROM book BX, author_of AOX "
          +"WHERE AOX.author_id = A.author_id AND AOX.isbn = BX.isbn)) = 0"
          +" ORDER BY A.author_id;";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);

          if (rs.last()){
            resultSet = new QueryResult.ResultQ5[rs.getRow()];
            rs.beforeFirst();
          }
          int i = 0;
          while (rs.next()){
            resultSet[i] = new QueryResult.ResultQ5(rs.getInt(1),rs.getString(2));
            i++;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return resultSet;
    }

    /**
     * List author_name(s) and isbn(s) of the book(s) written by "Selective" authors.
     * "Selective" authors are those who have worked with publishers that have
     * published their books only.(i.e., they haven't published books of
     * different authors)
     * @return QueryResult.ResultQ6[]
     */

    public QueryResult.ResultQ6[] functionQ6(){
      QueryResult.ResultQ6[] resultSet = null;
      try {
          String sql = ""
          +"SELECT AO.author_id, B.isbn "
          +"FROM author_of AO, book B "
          +"WHERE AO.isbn = B.isbn AND NOT EXISTS "
          +"(SELECT P.publisher_id "
          +"FROM publisher P "
          +"WHERE P.publisher_id IN "
          +"(SELECT DISTINCT BX.publisher_id "
          +"FROM book BX, author_of AOX "
          +"WHERE BX.isbn = AOX.isbn AND AOX.author_id = AO.author_id) "
          +"AND P.publisher_id NOT IN "
          +"(SELECT BX.publisher_id "
          +"FROM book BX, author_of AOX "
          +"WHERE BX.isbn = AOX.isbn "
          +"GROUP BY BX.publisher_id "
          +"HAVING COUNT(DISTINCT AOX.author_id) = 1)) "
          +"ORDER BY AO.author_id, B.isbn"
          +";";

          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);

          if (rs.last()){
            resultSet = new QueryResult.ResultQ6[rs.getRow()];
            rs.beforeFirst();
          }
          int i = 0;
          while (rs.next()){
            resultSet[i] = new QueryResult.ResultQ6(rs.getInt(1),rs.getString(2));
            i++;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return resultSet;
    }

    /**
     * List publisher_id and publisher_name of the publishers who have published
     * at least 2 books in  'Roman' category and average rating of their books
     * are more than (>) the given value.
     * @param rating
     * @return QueryResult.ResultQ7[]
     */
    public QueryResult.ResultQ7[] functionQ7(double rating){
      QueryResult.ResultQ7[] resultSet = null;
      try {
          String sql = ""
          +"SELECT P.publisher_id, P.publisher_name "
          +"FROM publisher P "
          +"WHERE (SELECT COUNT(BX.isbn) FROM book BX WHERE BX.category = 'Roman' AND BX.publisher_id = P.publisher_id) >= 2 "
          +"AND (SELECT AVG(BZ.rating) FROM book BZ WHERE BZ.publisher_id = P.publisher_id) > "+rating
          +" ORDER BY P.publisher_id;";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);

          if (rs.last()){
            resultSet = new QueryResult.ResultQ7[rs.getRow()];
            rs.beforeFirst();
          }
          int i = 0;
          while (rs.next()){
            resultSet[i] = new QueryResult.ResultQ7(rs.getInt(1),rs.getString(2));
            i++;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return resultSet;
    }

    /**
     * Some of the books  in the store have been published more than once:
     * although they have same names(book\_name), they are published with different
     * isbns. For each  multiple copy of these books, find the book_name(s) with the
     * lowest rating for each book_name  and store their isbn, book_name and
     * rating into phw1 table using a single BULK insertion query.
     * If there exists more than 1 with the lowest rating, then store them all.
     * After the bulk insertion operation, list isbn, book_name and rating of
     * all rows in phw1 table.
     * @return QueryResult.ResultQ8[]
     */

    public QueryResult.ResultQ8[] functionQ8(){
      // Update
      try {
          String sql = "INSERT INTO phw1(isbn,book_name,rating) "
          +"SELECT BX1.isbn, BX1.book_name, BX1.rating "
          +"FROM book BX1, book BX2 "
          +"WHERE BX1.book_name = BX2.book_name AND BX1.isbn <> BX2.isbn "
          +"AND BX1.rating = (SELECT MIN(BZ.rating) FROM book BZ WHERE BZ.book_name = BX1.book_name) "
          +";";
          Statement st = connection.createStatement();
          st.executeUpdate(sql);
      } catch (SQLException e) {
          e.printStackTrace();
      }
      // Select
      QueryResult.ResultQ8[] resultSet = null;
      try {
          String sql = ""
          +"SELECT isbn, book_name, rating FROM phw1"
          +" ORDER BY isbn;";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);

          if (rs.last()){
            resultSet = new QueryResult.ResultQ8[rs.getRow()];
            rs.beforeFirst();
          }
          int i = 0;
          while (rs.next()){
            resultSet[i] = new QueryResult.ResultQ8(rs.getString(1),rs.getString(2),rs.getDouble(3));
            i++;
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return resultSet;
    }

    /**
     * For the books that contain the given keyword anywhere in their names,
     * increase their ratings by one.
     * Please note that, the maximum rating cannot be more than 5,
     * therefore if the previous rating is greater than 4, do not update the
     * rating of that book.
     * @param keyword
     * @return sum of the ratings of all books
     */

    public double functionQ9(String keyword){
      // Update
      try {
          String sql = ""
          +"UPDATE book SET rating = rating + 1 "
          +"WHERE book_name LIKE \"%"+keyword+"%\" "
          +"AND rating <= 4"
          +";";
          Statement st = connection.createStatement();
          st.executeUpdate(sql);
      } catch (SQLException e) {
          e.printStackTrace();
      }
      // Select
      double sum = 0.0;
      try {
          String sql = ""
          +"SELECT SUM(rating) FROM book"
          +";";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);
          while (rs.next()){
            sum = rs.getDouble(1);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return sum;
    }

    /**
     * Delete publishers in publisher table who haven't published a book yet.
     * @return count of all rows of the publisher table after delete operation.
     */
    public int function10(){
      // Delete
      try {
          String sql = ""
          +"DELETE FROM publisher WHERE publisher_id NOT IN (SELECT DISTINCT B.publisher_id FROM book B)"
          +";";
          Statement st = connection.createStatement();
          st.executeUpdate(sql);
      } catch (SQLException e) {
          e.printStackTrace();
      }
      // Select
      int count = 0;
      try {
          String sql = ""
          +"SELECT COUNT(*) FROM publisher"
          +";";
          Statement st = connection.createStatement();
          ResultSet rs = st.executeQuery(sql);
          while (rs.next()){
            count = rs.getInt(1);
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
      return count;
    }

}
