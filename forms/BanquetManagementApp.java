package forms;

import db.DBConnection;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;
import java.util.Vector;

public class BanquetManagementApp {

    static class LoginForm extends JFrame {
        JTextField nameField;
        JPasswordField passField;

        LoginForm() {
            setTitle("Login");
            setSize(300, 200);
            setLayout(new GridLayout(4, 2));

            add(new JLabel("Customer Name:"));
            nameField = new JTextField();
            add(nameField);

            add(new JLabel("Password:"));
            passField = new JPasswordField();
            add(passField);

            JButton loginBtn = new JButton("Login");
            JButton regBtn = new JButton("Register");
            add(loginBtn);
            add(regBtn);

            loginBtn.addActionListener(e -> login());
            regBtn.addActionListener(e -> {
                dispose();
                new RegisterForm();
            });

            setDefaultCloseOperation(EXIT_ON_CLOSE);
            setVisible(true);
        }

        void login() {
            String name = nameField.getText();
            String pass = new String(passField.getPassword());
            try (Connection con = DBConnection.connect();PreparedStatement pst = con.prepareStatement("SELECT * FROM Customer WHERE Name=? AND Password=?")) {
                pst.setString(1, name);
                pst.setString(2, pass);
                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    JOptionPane.showMessageDialog(this, "Login successful!");
                    dispose();
                    new DashboardForm();
                } else {
                    JOptionPane.showMessageDialog(this, "Invalid credentials.");
                }
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, ex.getMessage());
            }
        }
    }

    static class RegisterForm extends JFrame {
        JTextField idField, nameField, contactField, emailField, addressField;
        JPasswordField passField;

        RegisterForm() {
            setTitle("Register Customer");
            setSize(400, 300);
            setLayout(new GridLayout(7, 2));

            add(new JLabel("Customer ID (e.g. C001):"));
            idField = new JTextField();
            add(idField);

            add(new JLabel("Name:"));
            nameField = new JTextField();
            add(nameField);

            add(new JLabel("Contact:"));
            contactField = new JTextField();
            add(contactField);

            add(new JLabel("Email:"));
            emailField = new JTextField();
            add(emailField);

            add(new JLabel("Address:"));
            addressField = new JTextField();
            add(addressField);

            add(new JLabel("Password:"));
            passField = new JPasswordField();
            add(passField);

            JButton registerBtn = new JButton("Register");
            add(registerBtn);

            registerBtn.addActionListener(e -> registerCustomer());

            setDefaultCloseOperation(EXIT_ON_CLOSE);
            setVisible(true);
        }

        void registerCustomer() {
            try (Connection con = DBConnection.connect(); PreparedStatement pst = con.prepareStatement(
                    "INSERT INTO Customer (CustomerID, Name, Contact, Email, Address, Password) VALUES (?, ?, ?, ?, ?, ?)")) {
                pst.setString(1, idField.getText());
                pst.setString(2, nameField.getText());
                pst.setString(3, contactField.getText());
                pst.setString(4, emailField.getText());
                pst.setString(5, addressField.getText());
                pst.setString(6, new String(passField.getPassword()));

                pst.executeUpdate();
                JOptionPane.showMessageDialog(this, "Customer Registered Successfully!");
                dispose();
                new LoginForm();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, ex.getMessage());
            }
        }
    }

    static class DashboardForm extends JFrame {
        DashboardForm() {
            setTitle("Customer Dashboard");
            setSize(400, 400);
            setLocationRelativeTo(null);
            setDefaultCloseOperation(EXIT_ON_CLOSE);
            setLayout(new GridBagLayout());
            GridBagConstraints gbc = new GridBagConstraints();

            JLabel welcomeLabel = new JLabel("Welcome to the Banquet Management System!");
            welcomeLabel.setFont(new Font("Arial", Font.BOLD, 14));
            gbc.gridx = 0;
            gbc.gridy = 0;
            gbc.insets = new Insets(10, 10, 20, 10);
            add(welcomeLabel, gbc);

            String[] buttons = {
                    "Book an Event",
                    "Make a Payment",
                    "View Event Types",
                    "View Banquets",
                    "Logout"
            };

            for (int i = 0; i < buttons.length; i++) {
                JButton btn = new JButton(buttons[i]);
                btn.setPreferredSize(new Dimension(200, 30));
                gbc.gridy = i + 1;
                add(btn, gbc);

                switch (buttons[i]) {
                    case "Book an Event" -> btn.addActionListener(e -> new BookingForm());
                    case "Make a Payment" -> btn.addActionListener(e -> new PaymentForm());
                    case "View Event Types" -> btn.addActionListener(e -> new EventTypeForm());
                    case "View Banquets" -> btn.addActionListener(e -> new BanquetForm());
                    case "Logout" -> btn.addActionListener(e -> {
                        dispose();
                        new LoginForm();
                    });
                }
            }
            setVisible(true);
        }
    }

    
    static class BookingForm extends JFrame {
    JTextField bookingIdField, customerIdField, banquetIdField, eventIdField, dateField, durationField;
    JButton addBtn, viewBtn, updateBtn, deleteBtn;

    BookingForm() {
        setTitle("Booking Form");
        setSize(400, 400);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        setLayout(new GridLayout(9, 2, 5, 5));

        bookingIdField = new JTextField();
        customerIdField = new JTextField();
        banquetIdField = new JTextField();
        eventIdField = new JTextField();
        dateField = new JTextField(); // Format: YYYY-MM-DD
        durationField = new JTextField();

        add(new JLabel("Booking ID (e.g., B001):")); add(bookingIdField);
        add(new JLabel("Customer ID:")); add(customerIdField);
        add(new JLabel("Banquet ID:")); add(banquetIdField);
        add(new JLabel("Event ID:")); add(eventIdField);
        add(new JLabel("Event Date (YYYY-MM-DD):")); add(dateField);
        add(new JLabel("Duration (days):")); add(durationField);

        addBtn = new JButton("Add");
        viewBtn = new JButton("View");
        updateBtn = new JButton("Update");
        deleteBtn = new JButton("Delete");

        add(addBtn); add(viewBtn);
        add(updateBtn); add(deleteBtn);

        addBtn.addActionListener(e -> addBooking());
        viewBtn.addActionListener(e -> viewBooking());
        updateBtn.addActionListener(e -> updateBooking());
        deleteBtn.addActionListener(e -> deleteBooking());

        setVisible(true);
    }

    void addBooking() {
        try (Connection con = DBConnection.connect()) {
            PreparedStatement pst = con.prepareStatement("INSERT INTO Booking (BookingID, CustomerID, BanquetID, EventID, EventDate, Duration, TotalCost) VALUES (?, ?, ?, ?, ?, ?, ?)");
            pst.setString(1, bookingIdField.getText());
            pst.setString(2, customerIdField.getText());
            pst.setString(3, banquetIdField.getText());
            pst.setString(4, eventIdField.getText());
            pst.setString(5, dateField.getText());
            int duration = Integer.parseInt(durationField.getText());
            pst.setInt(6, duration);

            // Fetch CostPerDay from Banquet table
            PreparedStatement costPst = con.prepareStatement("SELECT CostPerDay FROM Banquet WHERE BanquetID = ?");
            costPst.setString(1, banquetIdField.getText());
            ResultSet rs = costPst.executeQuery();
            if (rs.next()) {
                double cost = rs.getDouble("CostPerDay");
                double total = cost * duration;
                pst.setDouble(7, total);
                pst.executeUpdate();
                JOptionPane.showMessageDialog(this, "Booking added! TotalCost: ₹" + total);
            } else {
                JOptionPane.showMessageDialog(this, "Invalid Banquet ID");
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    void viewBooking() {
        try (Connection con = DBConnection.connect()) {
            PreparedStatement pst = con.prepareStatement("SELECT * FROM Booking WHERE BookingID = ?");
            pst.setString(1, bookingIdField.getText());
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                customerIdField.setText(rs.getString("CustomerID"));
                banquetIdField.setText(rs.getString("BanquetID"));
                eventIdField.setText(rs.getString("EventID"));
                dateField.setText(rs.getString("EventDate"));
                durationField.setText(rs.getString("Duration"));
                JOptionPane.showMessageDialog(this, "Booking found. TotalCost: ₹" + rs.getDouble("TotalCost"));
            } else {
                JOptionPane.showMessageDialog(this, "Booking not found!");
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    void updateBooking() {
        try (Connection con = DBConnection.connect()) {
            PreparedStatement pst = con.prepareStatement("UPDATE Booking SET CustomerID=?, BanquetID=?, EventID=?, EventDate=?, Duration=?, TotalCost=? WHERE BookingID=?");
            pst.setString(1, customerIdField.getText());
            pst.setString(2, banquetIdField.getText());
            pst.setString(3, eventIdField.getText());
            pst.setString(4, dateField.getText());
            int duration = Integer.parseInt(durationField.getText());
            pst.setInt(5, duration);

            // Recalculate TotalCost
            PreparedStatement costPst = con.prepareStatement("SELECT CostPerDay FROM Banquet WHERE BanquetID = ?");
            costPst.setString(1, banquetIdField.getText());
            ResultSet rs = costPst.executeQuery();
            if (rs.next()) {
                double cost = rs.getDouble("CostPerDay");
                double total = cost * duration;
                pst.setDouble(6, total);
                pst.setString(7, bookingIdField.getText());
                pst.executeUpdate();
                JOptionPane.showMessageDialog(this, "Booking updated! New TotalCost: ₹" + total);
            } else {
                JOptionPane.showMessageDialog(this, "Invalid Banquet ID");
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    void deleteBooking() {
        try (Connection con = DBConnection.connect()) {
            PreparedStatement pst = con.prepareStatement("DELETE FROM Booking WHERE BookingID = ?");
            pst.setString(1, bookingIdField.getText());
            int rows = pst.executeUpdate();
            if (rows > 0) {
                JOptionPane.showMessageDialog(this, "Booking deleted!");
                customerIdField.setText("");
                banquetIdField.setText("");
                eventIdField.setText("");
                dateField.setText("");
                durationField.setText("");
            } else {
                JOptionPane.showMessageDialog(this, "Booking ID not found.");
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }
}


    static class PaymentForm extends JFrame {
    JTextField paymentIDField, bookingIDField, amountField, dateField;
    JComboBox<String> methodBox, statusBox;

    PaymentForm() {
        setTitle("Payment Form");
        setSize(450, 400);
        setLayout(new GridLayout(8, 2, 10, 10));
        setLocationRelativeTo(null);

        add(new JLabel("Payment ID (e.g. P001):"));
        paymentIDField = new JTextField();
        add(paymentIDField);

        add(new JLabel("Booking ID (e.g. B001):"));
        bookingIDField = new JTextField();
        add(bookingIDField);

        add(new JLabel("Amount:"));
        amountField = new JTextField();
        add(amountField);

        add(new JLabel("Payment Method:"));
        String[] methods = {"Cash", "Credit Card", "UPI"};
        methodBox = new JComboBox<>(methods);
        add(methodBox);

        add(new JLabel("Payment Date (YYYY-MM-DD):"));
        dateField = new JTextField();
        add(dateField);

        add(new JLabel("Payment Status:"));
        String[] status = {"Completed", "Pending", "Failed"};
        statusBox = new JComboBox<>(status);
        add(statusBox);

        JButton saveBtn = new JButton("Save Payment");
        JButton viewBtn = new JButton("View Payment");
        add(saveBtn);
        add(viewBtn);

        saveBtn.addActionListener(e -> savePayment());
        viewBtn.addActionListener(e -> viewPayment());

        setVisible(true);
    }

    void savePayment() {
        String pid = paymentIDField.getText();
        String bid = bookingIDField.getText();
        String amt = amountField.getText();
        String method = methodBox.getSelectedItem().toString();
        String date = dateField.getText();
        String status = statusBox.getSelectedItem().toString();

        try (Connection con = DBConnection.connect(); PreparedStatement pst = con.prepareStatement(
                "INSERT INTO Payment (PaymentID, BookingID, Amount, PaymentMethod, PaymentDate, PaymentStatus) VALUES (?, ?, ?, ?, ?, ?)")) {
            pst.setString(1, pid);
            pst.setString(2, bid);
            pst.setDouble(3, Double.parseDouble(amt));
            pst.setString(4, method);
            pst.setString(5, date);
            pst.setString(6, status);

            pst.executeUpdate();
            JOptionPane.showMessageDialog(this, "Payment recorded successfully!");
            dispose();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    void viewPayment() {
        String pid = paymentIDField.getText();
        String bid = bookingIDField.getText();

        try (Connection con = DBConnection.connect(); PreparedStatement pst = con.prepareStatement(
                "SELECT * FROM Payment WHERE PaymentID = ? AND BookingID = ?")) {
            pst.setString(1, pid);
            pst.setString(2, bid);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String details = "Payment ID: " + rs.getString("PaymentID") +
                                 "\nBooking ID: " + rs.getString("BookingID") +
                                 "\nAmount: ₹" + rs.getDouble("Amount") +
                                 "\nMethod: " + rs.getString("PaymentMethod") +
                                 "\nDate: " + rs.getDate("PaymentDate") +
                                 "\nStatus: " + rs.getString("PaymentStatus");

                JOptionPane.showMessageDialog(this, details, "Payment Details", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(this, "No payment found with the given IDs.");
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }
}

static class EventTypeForm extends JFrame {
    JTextArea displayArea;

    EventTypeForm() {
        setTitle("View Event Types");
        setSize(500, 400);
        setLayout(new BorderLayout());
        setLocationRelativeTo(null);

        JButton viewBtn = new JButton("Load All Event Types");
        displayArea = new JTextArea();
        displayArea.setEditable(false);

        JScrollPane scrollPane = new JScrollPane(displayArea);

        add(viewBtn, BorderLayout.NORTH);
        add(scrollPane, BorderLayout.CENTER);

        viewBtn.addActionListener(e -> loadEventTypes());

        setVisible(true);
    }

    void loadEventTypes() {
        displayArea.setText("");
        try (Connection con = DBConnection.connect(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM EventType")) {
            while (rs.next()) {
                String info = "Event ID: " + rs.getString("EventID") +
                              "\nName: " + rs.getString("EventName") +
                              "\nDescription: " + rs.getString("Description") +
                              "\n-----------------------------\n";
                displayArea.append(info);
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error loading event types: " + ex.getMessage());
        }
    }
}
 

   static class BanquetForm extends JFrame {
    JTextArea displayArea;

    BanquetForm() {
        setTitle("View Banquet List");
        setSize(500, 400);
        setLayout(new BorderLayout());
        setLocationRelativeTo(null);

        JButton viewBtn = new JButton("Load All Banquets");
        displayArea = new JTextArea();
        displayArea.setEditable(false);

        JScrollPane scrollPane = new JScrollPane(displayArea);

        add(viewBtn, BorderLayout.NORTH);
        add(scrollPane, BorderLayout.CENTER);

        viewBtn.addActionListener(e -> loadBanquetData());

        setVisible(true);
    }

    void loadBanquetData() {
        displayArea.setText("");
        try (Connection con = DBConnection.connect(); 
             Statement st = con.createStatement(); 
             ResultSet rs = st.executeQuery("SELECT * FROM Banquet")) {
            
            while (rs.next()) {
                String info = "Banquet ID: " + rs.getString("BanquetID") +
                              "\nName: " + rs.getString("Name") +
                              "\nLocation: " + rs.getString("Location") +
                              "\nCapacity: " + rs.getInt("Capacity") +
                              "\nCost Per Day: ₹" + rs.getDouble("CostPerDay") +
                              "\n-----------------------------\n";
                displayArea.append(info);
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error loading banquet data: " + ex.getMessage());
        }
    }
}

    public static void main(String[] args) {
        new LoginForm();
    }
}
